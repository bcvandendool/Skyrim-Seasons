unit UserScript;

uses 'lib\mxpf';

function Initialize: Integer;
var 
	i, test: integer;
	rec: IInterface;
	x, y: string;
	sl: TStringList;
begin
	InitializeMXPF;
	DefaultOptionsMXPF;
	LoadChildRecords('WRLD', 'CELL');
	
	sl := TStringList.Create;
	sl.Add('	"string" :');
	sl.Add('	{');
	
	for i := 0 to MaxRecordIndex do begin
	
		rec := GetRecord(i);
		if String (geev(rec, 'Worldspace')) = 'Tamriel "Skyrim" [WRLD:0000003C]' then
		begin
			sl.Add('		"' + geev(rec, 'XCLC/X') + ':' + geev(rec, 'XCLC/Y') + '" : "' + IntToHex(FixedFormID(rec), 8) + ':' + GetFileName(GetFile(rec)) + '",');
			sl.Add('		"' + testFunction(IntToHex(FixedFormID(rec), 8)) + '" : "' + geev(rec, 'XCLC/X') + ':' + geev(rec, 'XCLC/Y') + '",')
		end;
		
	end;
	
	sl.Add('	}');
	
	PrintMXPFReport;
	FinalizeMXPF;
	sl.SaveToFile('test.txt');
	sl.Free;
	
end;

function testFunction(foo: String): String;
begin
	
	foo := ReverseString(foo);
	while StrEndsWith(foo, '0') do
		foo := RemoveFromEnd(foo, '0');
	
	foo := ReverseString(foo);
	Result := foo;
	
end;

end.
