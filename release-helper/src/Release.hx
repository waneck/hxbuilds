using haxe.io.Path;
import haxe.io.*;
import sys.io.*;

class Config {
	public var buildServerUrl:String;
	public var fileName:String;
	public var targets:Array<String>;
	public var haxeVersion:String;
	public var targetFileNameMap:Map<String, String>;
	
	public function new() {
		buildServerUrl = "http://hxbuilds.s3-website-us-east-1.amazonaws.com/builds/haxe/";
		targets = ["linux32", "linux64", "mac-installer", "mac", "windows-installer", "windows"];
		targetFileNameMap = [
			"linux32" => "linux32",
			"linux64" => "linux64",
			"mac-installer" => "osx-installer",
			"mac" => "osx",
			"windows-installer" => "win",
			"windows" => "win"
		];
	}
}

class Release {
	
	static var config = new Config();
	static var handledTargets = 0;
	static var failed = false;
	
	static function main() {
		var argParser = hxargs.Args.generate([
			@doc("The base server URL to fetch builds from")
			"-serverUrl" => function(url:String) {
				config.buildServerUrl = url.addTrailingSlash();
			},
			@doc("Which Haxe version to generate, e.g. 3.1.0")
			"-haxeVersion" => function(version:String) {
				config.haxeVersion = version;
			},
			@doc("The file name to fetch")
			"-fileName" => function(fileName:String) {
				config.fileName = fileName;
			},
		]);
		
		argParser.parse(Sys.args());
		
		if (config.fileName == null) {
			Sys.println("Required argument -fileName is missing");
			Sys.println(argParser.getDoc());
			Sys.exit(1);
		} else if (config.haxeVersion == null) {
			Sys.println("Required argument -haxeVersion is missing");
			Sys.println(argParser.getDoc());
			Sys.exit(1);
		}
		
		Sys.println("Downloading files");

		for (target in config.targets) {
			neko.vm.Thread.create(handleTarget.bind(target));
		}
				
		while(handledTargets < config.targets.length) { }
		
		if (failed) {
			Sys.println("Command " + Sys.args().join(" ") + " failed");
			Sys.exit(1);
		} else {
			Sys.println("Done!");
			Sys.exit(0);
		}
	}

	static function handleTarget(target:String) {
		try {
			var url = Path.join([config.buildServerUrl, target, config.fileName]);
			Sys.println('Requesting $url');
			var request = new haxe.Http(url);
			request.onData = onData.bind(target);
			request.onError = onError.bind(target);
			request.request();
		} catch(e:Dynamic) {
			Sys.println('On target $target');
			failed = true;
			handledTargets++;
			throw e;
		}
	}
	
	static function unpack(s:String) {
		var gzReader = new format.gz.Reader(new StringInput(s));
		var out = new BytesOutput();
		gzReader.readHeader();
		gzReader.readData(out);
		var tarReader = new format.tar.Reader(new BytesInput(out.getBytes()));
		return tarReader.read();
	}
	
	static function zip(data:List<format.tar.Data.Entry>) {
		var entries = new List();
		for (file in data) {
			var entry = {
				fileName: file.fileName,
				fileSize: file.data.length,
				fileTime: Date.now(),
				compressed: false,
				dataSize: file.data.length,
				data: file.data,
				crc32: haxe.crypto.Crc32.make(file.data),
				extraFields: null
			};
			haxe.zip.Tools.compress(entry, 1);
			entries.add(entry);
		}
		return entries;
	}
	
	static function onData(target:String, s:String) {
		Sys.println('Received content for $target');
		var name = 'haxe-${config.haxeVersion}-${config.targetFileNameMap[target]}';
		if (!sys.FileSystem.exists(config.haxeVersion)) {
			sys.FileSystem.createDirectory(config.haxeVersion);
		}
		name = config.haxeVersion + "/" + name;
		switch(target) {
			case "linux32" | "linux64" | "mac":
				File.saveContent(name + ".tar.gz", s);
			case "windows":
				var data = unpack(s);
				var zipEntries = zip(data);
				var output = File.write(name + ".zip");
				var zip = new haxe.zip.Writer(output);
				zip.write(zipEntries);
			case "mac-installer":
				var data = unpack(s);
				File.saveBytes(name + ".pkg", data.first().data);
			case "windows-installer":
				var data = unpack(s);
				File.saveBytes(name + ".exe", data.first().data);
		}
		handledTargets++;

	}
	
	static function onError(target:String, s:String) {
		Sys.println('Could not retrieve content for $target: $s');
		failed = true;
		handledTargets++;
	}
}