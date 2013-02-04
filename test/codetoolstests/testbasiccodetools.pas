{
 Test with:
   ./runtests --format=plain --suite=TTestBasicCodeTools
   ./runtests --format=plain --suite=TestFindLineEndOrCodeInFrontOfPosition
   ./runtests --format=plain --suite=TestHasTxtWord
   ./runtests --format=plain --suite=TestBasicFindCommentEnd
   ./runtests --format=plain --suite=TestBasicFindNextComment
   ./runtests --format=plain --suite=TestCompareTextIgnoringSpace
}
unit TestBasicCodetools;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, Classes, SysUtils, testglobals, FileProcs, BasicCodeTools;

type
  { TTestBasicCodeTools }

  TTestBasicCodeTools = class(TTestCase)
  protected
  published
    procedure TestFindLineEndOrCodeInFrontOfPosition;
    procedure TestHasTxtWord;
    procedure TestBasicFindCommentEnd;
    procedure TestBasicFindNextComment;
    procedure TestCompareTextIgnoringSpace;
  end;

implementation

{ TTestBasicCodeTools }

procedure TTestBasicCodeTools.TestFindLineEndOrCodeInFrontOfPosition;

  procedure t(Src: string; SkipSemicolonComma: boolean = true;
    StopAtDirectives: boolean = true;
    SkipEmptyLines: boolean = false; NestedComments: boolean = true);
  var
    Position: integer;
    Expected: integer;
    Actual: LongInt;
    OrigSrc: String;
  begin
    OrigSrc:=Src;
    Expected:=Pos('$',Src);
    if Expected<1 then
      raise Exception.Create('TTestBasicCodeTools.TestFindLineEndOrCodeInFrontOfPosition missing # expected position');
    Delete(Src,Expected,1);
    Position:=Pos('|',Src);
    if Position<1 then
      raise Exception.Create('TTestBasicCodeTools.TestFindLineEndOrCodeInFrontOfPosition missing | start position');
    Delete(Src,Position,1);
    Actual:=FindLineEndOrCodeInFrontOfPosition(Src,Position,1,NestedComments,
      StopAtDirectives,SkipSemicolonComma,SkipEmptyLines);
    AssertEquals('['+dbgstr(OrigSrc)+']',Expected,Actual);
  end;

var
  e: String;
begin
  //writeln('TTestBasicCodeTools.TestFindLineEndOrCodeInFrontOfPosition ');
  e:=#13#10; // use windows line endings, they are more complicated
  t(' $'+e+'|a:=1;');
  t('a$'+e+'// comment'+e+' { comment } '+e+'|');
  t('$'+e+' (* *)'+e+' |a:=1');
  t('a:=1;(* comment of first line'+e+' *)$ |b:=1');
  t('a:=1; // comment$'+e+'|b:=1');
  t('a:=1; (* comment'+e+' *) $'+e+'|b:=1');
  t('a:=1; (* comment'+e+' *) { comment'+e+' } $'+e+'|b:=1');
end;

procedure TTestBasicCodeTools.TestHasTxtWord;

  procedure t(aWord,aText: PChar; ExpectedWholeWord: boolean; ExpectedCount: SizeInt);
  var
    WholeWord: boolean;
    Count: SizeInt;
  begin
    HasTxtWord(aWord,aText,WholeWord,Count);
    AssertEquals('Word="'+aWord+'" Text="'+aText+'" WholeWord',ExpectedWholeWord,WholeWord);
    AssertEquals('Word="'+aWord+'" Text="'+aText+'" Count',ExpectedCount,Count);
  end;

begin
  t(nil,nil,false,0);
  t('a','a',true,1);
  t('ab','a',false,0); // ab not in a
  t('a','ab',false,1); // a in ab
  t('a','aba',false,2);
  t('a','a a',true,2);
  t('a','ab a',true,1);
  t('abc','ab abcd',false,1);
  t('ab','abab',false,2);
end;

procedure TTestBasicCodeTools.TestBasicFindCommentEnd;

  procedure TestFindCommentEnd(Src: string;
    NestedComments: boolean; ExpectedEndPos: integer);
  var
    EndPos: Integer;
    p: PChar;
    EndP: PChar;
  begin
    EndPos:=FindCommentEnd(Src,1,NestedComments);
    AssertEquals('FindCommentEnd(string) '+dbgstr(Src),ExpectedEndPos,EndPos);
    p:=PChar(Src);
    EndP:=FindCommentEnd(p,NestedComments);
    EndPos:=EndP-PChar(Src)+1;
    AssertEquals('FindCommentEnd(pchar) '+dbgstr(Src),ExpectedEndPos,EndPos);
  end;

begin
  TestFindCommentEnd(' ',false,1);
  TestFindCommentEnd('{}',false,3);
  TestFindCommentEnd('(**)',false,5);
  TestFindCommentEnd('(*)',false,4);
  TestFindCommentEnd('{{}}',false,4);
  TestFindCommentEnd('{{}}',true,5);
  TestFindCommentEnd('{'#3#3'}',false,5);
  TestFindCommentEnd('{'#3'}'#3'}',false,6);
  TestFindCommentEnd('//',false,3);
end;

procedure TTestBasicCodeTools.TestBasicFindNextComment;

  procedure TestFindNextComment(Src: string; ExpectedPos: integer);
  var
    StartPos: Integer;
  begin
    StartPos:=FindNextComment(Src,1);
    AssertEquals('FindNextComment '+dbgstr(Src),ExpectedPos,StartPos);
  end;

begin
  TestFindNextComment('{',1);
  TestFindNextComment('//',1);
  TestFindNextComment('(*',1);
  TestFindNextComment('(',2);
  TestFindNextComment('/',2);
end;

procedure TTestBasicCodeTools.TestCompareTextIgnoringSpace;

  procedure t(Txt1, Txt2: string; Expected: integer; CaseSensitive: boolean = false);
  var
    r: Integer;
  begin
    r:=CompareTextIgnoringSpace(Txt1,Txt2,CaseSensitive);
    AssertEquals('Txt1="'+dbgstr(Txt1)+'",Txt2="'+dbgstr(Txt2)+'"',Expected,r);
  end;

begin
  t('a','a',0);
  t('a','A',0);
  t('a',' a',0);
  t(' a','a',0);
  t(' a','a ',0);
  t(' a: b','a:b',0);
  t('procedure TCustomSynEdit.LineCountChanged(Sender: TSynEditStrings; AIndex,'#13#10'  ACount: Integer); ',
    'procedure TCustomSynEdit.LineCountChanged(Sender: TSynEditStrings; AIndex, ACount: Integer);',0);
end;

initialization
  AddToCodetoolsTestSuite(TTestBasicCodeTools);

end.

