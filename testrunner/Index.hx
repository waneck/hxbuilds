import db.Revision;
import haxe.web.Dispatch;
import neko.Web;
import sys.db.Manager;
import db.TestResult;

using Lambda;
using StringTools;

class Index
{

	function new()
	{
	}

	static function main()
	{
		Env.init();
		var uri = Web.getURI();
		if (uri.endsWith("index.n"))
			uri = uri.substr(0,uri.length-7);
		Dispatch.run(uri, Web.getParams(), new Index());
		Manager.cnx.close();
	}

	public function doDefault()
	{
		//get latest Revisions for each project
		var revs = Revision.manager.unsafeObjects('SELECT t1.* FROM Revision t1 JOIN (select MAX(id) as t2_id FROM Revision GROUP BY project) t2 ON t1.id = t2.t2_id', false);
		var projs = [];
		for (rev in revs)
		{
			projs.push({
				title: rev.project + " " + rev.revision,
				tests: getTestsObject(rev)
			});
		}
		Sys.println(new view.TestView().setData({ projects: projs }).execute());
	}

	public function doP(project:String, revision:String)
	{
		var rev = Revision.manager.select($project == project && $revision == revision,null,false);
		var projs =[{ title: rev.project + " " + rev.revision, tests:getTestsObject(rev) }];
		Sys.println(new view.TestView().setData({ projects: projs }).execute());
	}

	public function doResult(r:TestResult)
	{
		var view = {
			testPart: r.testPart.title,
			target: r.target,
			project: r.revision.project,
			revision: r.revision.revision,

			stdout: r.stdout,
			stderr: r.stderr,

			results: TestResult.manager.search($testPart == r.testPart && $target == r.target && $revision_id < r.revision.id, { limit:20, orderBy:[-dateRan] }, false)
				.map(function(r) return { rev: r.revision.revision, date: r.dateRan, status: (r.success ? "gtest" : "rtest"), id: r.id }).array()
		};
		Sys.println(new view.ResultView().setData(view).execute());
	}

	static function getTestsObject(rev:Revision):Array<{ title:String, targets:Array<{ name:String, results:Array<{cls:String, id:Int}> }> }>
	{
		var parts = null, ret = [], curTarget = null, curTest = null, cur = null;
		for (r in Manager.cnx.request('SELECT t1.*, t2.title as part_title, t2.name as part_name, t3.title as test_title, t3.name as test_name FROM TestResult t1 JOIN TestPart t2 ON t1.testPart_id = t2.id JOIN Test t3 ON t2.test_id = t3.id WHERE revision_id = ' + Manager.quoteAny(rev.id) + ' ORDER BY t3.name, t1.target'))
		{
			if (r.test_name != curTest)
			{
				cur = { title: r.test_title, targets: [] };
				curTarget = null;
				curTest = r.test_name;
				parts = [];
				ret.push(cur);
			}

			if (r.target != curTarget)
			{
				curTarget = r.target;
				cur.targets.push({ name: r.target, results:[] });
			}

			var targetPos = parts.indexOf(r.part_name);
			if (targetPos < 0)
				targetPos = parts.push(r.part_name) - 1;
			var suc = untyped r.success || r.success == 1; //sqlite vs mysql
			cur.targets[cur.targets.length - 1].results[targetPos] = { cls:(suc ? "gtest" : "rtest"), id:r.id };
		}

		for(r in ret)
			for(t in r.targets)
			{
				for(i in 0...t.results.length)
				{
					if (t.results[i] == null)
					{
						t.results[i] = { cls: "ytest", id:0 };
					}
				}
			}
		return ret;
	}

}
