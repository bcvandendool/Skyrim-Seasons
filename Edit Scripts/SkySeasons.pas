unit UserScript;

uses 'lib\mxpf';

function Initialize: Integer;
var 
	i, i2, i3, test: integer;
	rec: IInterface;
	x, y, s, s2, MOdirectory: string;
	sl, splitter, splitter2, filelist: TStringList;
	element: IwbElement;
begin
	InitializeMXPF;
	DefaultOptionsMXPF;
	sl := TStringList.Create;
	filelist := TStringList.Create;
	
	LoadRecords('FLOR');
	sl.Add('Flora:');
	sl.Add(' ');
	
	for i := MaxRecordIndex downto 0 do begin
	
		rec := GetRecord(i);
		sl.Add(geev(rec, 'FULL') + ' : ' + geev(rec, 'Model/MODL'));
		filelist.Add(geev(rec, 'Model/MODL'));
		RemoveRecord(i);
		
	end;
	
	sl.Add(' ');
	sl.Add('Grass: ');
	sl.Add(' ');
	
	LoadRecords('GRAS');
	
	for i := MaxRecordIndex downto 0 do begin
	
		rec := GetRecord(i);
		sl.Add(geev(rec, 'Model/MODL'));
		filelist.Add(geev(rec, 'Model/MODL'));
		RemoveRecord(i);
		
	end;
	
	sl.Add(' ');
	sl.Add('Landscape Textures: ');
	sl.Add(' ');
	
	LoadRecords('LTEX');
	
	for i := MaxRecordIndex downto 0 do begin
	
		rec := GetRecord(i);
		sl.Add(geev(rec, 'TNAM') + ' : ' + geev(rec, 'MNAM'));
		s := geev(rec, 'TNAM');
		splitter := TStringList.Create;
		splitter.StrictDelimiter := true;
		splitter.Delimiter := ':';
		splitter.DelimitedText := s;
	//	Only doing this works. I have no idea why.;
		for i2 := 0 to splitter.Count-2 do begin

			sl.Add(delete(splitter[1], length(splitter[1]), 1));
			rec := RecordByHexFormID(sl[sl.Count-1]);
			s2 := gav(rec);
			splitter2 := TStringList.Create;
			splitter2.StrictDelimiter := true;
			splitter2.Delimiter := ';';
			splitter2.DelimitedText := s2;
			for i3 := 0 to splitter2.Count-1 do begin

				// want 16 & 17
				if ( i3 = 15 ) then 
				begin
					sl.Add(splitter2[i3]);
					filelist.Add(splitter2[i3])
				end
				else if ( i3 = 16 ) then
				begin
					sl.Add(splitter2[i3]);
					filelist.Add(splitter2[i3])
				end
				else
				begin
					
				end;

			end;

		end;
		RemoveRecord(i);
		
	end;
	
	sl.Add('');
	sl.Add('Trees: ');
	sl.Add('');

	LoadRecords('TREE');

	for i := MaxRecordIndex downto 0 do begin

		rec := GetRecord(i);
		sl.Add(geev(rec, 'Model/MODL'));
		filelist.Add(geev(rec, 'Model/MODL'));
		RemoveRecord(i);

	end;

	PrintMXPFReport;
	FinalizeMXPF;

	MOdirectory :=

	for i := 0 to filelist.Count-1 do begin

		s := filelist[i]
		if Matches(s, '*.dds') then
		begin



		else if Matches(s, '*.nif') then
		begin


		
		else
		begin

		end;

	end;

	filelist.SaveToFile('filelist.txt');
	filelist.Free;
	sl.SaveToFile('test.txt');
	sl.Free;
	
end;

end.
