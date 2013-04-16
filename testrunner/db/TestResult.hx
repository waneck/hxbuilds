package db;
import sys.db.Object;
import sys.db.Types;

@:index(revision_id,testPart_id,target,unique)
class TestResult extends Object
{
	public var id:SId;

	@:relation(revision_id) public var revision:Revision;
	@:relation(testPart_id) public var testPart:TestPart;
	public var target:SString<10>; //target name, e.g. java
	public var dateRan:SDateTime;

	public var success:SBool;
	public var exitCode:SInt;
	public var stdout:Null<SText>;
	public var stderr:Null<SText>;
	public var executionTime:SFloat;
}
