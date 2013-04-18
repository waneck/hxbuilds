package view;
import erazor.macro.SimpleTemplate;

@:includeTemplate('../www/result.erazor.html')
class ResultView extends erazor.macro.SimpleTemplate<{
	testPart:String,
	target:String,
	project:String,
	revision:String,

	stdout:String,
	stderr:String,

	results:Array<{ rev:String, date:Date, status:String, id:Int }>
}>

{
}
