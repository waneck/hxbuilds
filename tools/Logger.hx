import sys.io.*;
import neko.vm.Thread;
import neko.vm.Lock;
using StringTools;

class Logger
{
	static function main()
	{
		var s3path = Sys.getEnv('S3_LOG_PATH'),
		    logpath = Sys.getEnv('LOG_PATH');
		if (s3path == null) throw 'S3_LOG_PATH must be defined';
		if (logpath == null) throw 'LOG_PATH must be defined';
		if (!sys.FileSystem.exists(logpath)) {
			sys.FileSystem.createDirectory(logpath);
		}
		var name = Sys.args()[0];
		if (s3path == null) throw 'usage: logger logname program [arg1] [arg2] ... [argN]';

		var args = Sys.args().slice(1);
		var timeout = Std.parseInt(Sys.getEnv('PRG_TIMEOUT'));
		if (timeout == null) {
			timeout = 3 * 60; // 3 minutes timeout
		}
		inline function escapeArgs(args:Array<String>) {
			return [ for (arg in args) "'" + arg.replace("\\","\\\\").replace("'", "\\'").replace('"', '\\"') + "'" ].join(' ');
		}

		var allArgs = escapeArgs(args);

		// bash-ception: we need to redirect both stderr and stdout to the same stream; but we need to do it on the main bash process
		var proc = new Process('/bin/bash',['-c', '/bin/bash -xve -c "export SHELLOPTS; $allArgs" 2>&1']);
		var lock = new Lock();
		var uploader = spawnUploader(s3path, logpath, name, 30, lock);
		spawnTimeout(timeout, uploader); // please process do not hang

		var writer = File.write('$logpath/$name.txt');
		writer.writeString('Starting at ${Date.now()}\n');
		try
		{
			var i = proc.stdout;
			var time = Date.now().getTime();
			while(true)
			{
				var ln = i.readLine();
				Sys.println(ln);
				writer.writeString(ln);
				writer.writeByte('\n'.code);
				var t2 = Date.now().getTime();
				if (t2 - time > 1000) {
					time = t2;
					writer.flush();
				}
			}
		}
		catch(e:haxe.io.Eof) {}

		var exit = proc.exitCode();
		writer.writeString('Ended at ${Date.now()} with exit code $exit');
		writer.close();
		var allerr = proc.stderr.readAll().toString();
		if (allerr.length > 0) {
			Sys.stderr().writeString(allerr);
		}

		lock.release();
		var msg = Thread.readMessage(true);
		if (msg == 'error') {
			Sys.exit(1);
		}

		Sys.exit(exit);
	}


	private static function spawnUploader(s3path:String, logpath:String, name:String, seconds:Float, lock:Lock):Thread {
		var caller = neko.vm.Thread.current();

		return Thread.create(function() {
			var lastLen = 0;
			var breakMsg = null;
			while(true) {
				if (lock.wait(seconds)) {
					breakMsg = 'ok';
				}

				// var len = sys.FileSystem.stat(logpath).size;
				// if (len == lastLen) {
				// 	if (breakMsg != null) break; else continue;
				// }
				// lastLen = len;
				var proc = new Process('/bin/bash', ['-c', 's3cmd sync "$logpath/$name.txt" "$s3path/$name.txt" > /dev/null 2> /dev/null']);
				var exit = proc.exitCode();
				if (exit != 0) {
					Sys.stderr().writeString('  -> ERROR sending log $name to $s3path\n');
				}
				if (breakMsg != null) break;
				breakMsg = Thread.readMessage(false);
			}

			caller.sendMessage(breakMsg);
		});
	}

	private static function spawnTimeout(secs:Int, uploader:Thread):Thread
	{
		return Thread.create(function() {
			Sys.sleep(secs);
			uploader.sendMessage('error');
			// give a while for sending the last log, but break if it takes too long
			Sys.sleep(40);
			Sys.exit(1); //the thread will die if the program exists before this time
		});
	}
}

