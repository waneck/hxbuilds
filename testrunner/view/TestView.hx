package view;
import erazor.macro.SimpleTemplate;

@:includeTemplate('../www/index.erazor.html')
class TestView extends erazor.macro.SimpleTemplate<{
	projects:Array<{
		title:String,
		tests:Array<{
			title:String,
			targets:Array<{ name:String, results:Array<{cls:String, id:Int}> }>
		}>
	}>
}>

{
}
