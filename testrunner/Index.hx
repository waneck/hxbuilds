class Index
{

	function new()
	{
	}

	static function main()
	{

		Sys.println(new view.TestView().setData({ projects:[] }).execute());
	}

}
