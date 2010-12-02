{ Search all lpk files, tell what lpl files are missing, too much or need change

  Copyright (C) 2010 Mattias Gaertner mattias@freepascal.org

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

program lplupdate;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, CustApp, FileProcs, contnrs, Laz_XMLCfg;

type

  { TPackage }

  TPackage = class
  public
    Filename: string;
    Name: string;
    Major: integer;
    Minor: integer;
    Release: integer;
    Build: integer;
    function VersionAsString: string;
  end;

  { TPackages }

  TPackages = class(TObjectList)
  private
    function GetPackages(Index: integer): TPackage;
  public
    function IndexByName(PkgName: string): integer;
    function FindByName(PkgName: string): TPackage;
    property Packages[Index: integer]: TPackage read GetPackages; default;
  end;

  { TLink }

  TLink = class
  public
    Filename: string;
    InLazarusDir: boolean; // PkgFilename starts with $(LazarusDir)
    PkgName: string;
    Major: integer;
    Minor: integer;
    Release: integer;
    Build: integer;
    PkgFilename: string;
    ExpFilename: string; // PkgFilename without macros
  end;

  { TLinks }

  TLinks = class(TObjectList)
  private
    function GetLinks(Index: integer): TLink;
  public
    function FindLinkWithName(PkgName: string): TLink;
    property Links[Index: integer]: TLink read GetLinks; default;
  end;

  { TLPLUpdate }

  TLPLUpdate = class(TCustomApplication)
  private
    FLazarusDir: string;
    FLinksDir: string;
    FPkgDir: string;
    FQuiet: Boolean;
    FVerbose: Boolean;
    FWriteCommands: boolean;
  protected
    procedure DoRun; override;
    procedure Error(Msg: string);
    procedure ScanPackages(Dir: string; Packages: TPackages);
    procedure ScanPackage(Filename: string; Packages: TPackages);
    procedure ScanLinks(Dir: string; Links: TLinks);
    procedure ScanLink(Filename: string; Links: TLinks);
    procedure WriteMissingLinks(Packages: TPackages; Links: TLinks);
    procedure WriteDeadLinks(Links: TLinks);
    procedure WriteLinksWithWrongVersion(Packages: TPackages; Links: TLinks);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    function GetDefaultLazarusDir: string;
    function GetLazarusDir: string;
    function GetDefaultPkgDirectory: string;
    function GetDefaultLinksDirectory: string;
    property LazarusDir: string read FLazarusDir write FLazarusDir;
    property PkgDir: string read FPkgDir write FPkgDir;
    property LinksDir: string read FLinksDir write FLinksDir;
    property Verbose: Boolean read FVerbose write FVerbose;
    property Quiet: Boolean read FQuiet write FQuiet;
    property WriteCommands: boolean read FWriteCommands write FWriteCommands;
  end;

{ TLPLUpdate }

procedure TLPLUpdate.DoRun;
var
  ErrorMsg: String;
  Packages: TPackages;
  Links: TLinks;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('hvqlLpc','help verbose quiet lazarusdir pkgdir linksdir commands');
  if ErrorMsg<>'' then begin
    Error(ErrorMsg);
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  Verbose:=HasOption('v','verbose');
  Quiet:=HasOption('q','quiet');

  if HasOption('L','lazarusdir') then
    LazarusDir:=CleanAndExpandDirectory(GetOptionValue('L','lazarusdir'))
  else
    LazarusDir:=GetDefaultLazarusDir;
  if not DirectoryExistsUTF8(LazarusDir) then
    Error('lazarus directory not found: '+LazarusDir);

  if HasOption('p','pkgdir') then
    PkgDir:=GetOptionValue('P','pkgdir')
  else
    PkgDir:=GetDefaultPkgDirectory;
  if not DirectoryExistsUTF8(PkgDir) then
    Error('package directory not found: '+PkgDir);

  if HasOption('l','pkgdir') then
    LinksDir:=GetOptionValue('P','pkgdir')
  else
    LinksDir:=GetDefaultLinksDirectory;
  if not DirectoryExistsUTF8(LinksDir) then
    Error('links directory not found: '+LinksDir);

  WriteCommands:=HasOption('c','commands');

  if Verbose then begin
    writeln('TLPLUpdate.DoRun LazarusDir=',LazarusDir);
    writeln('TLPLUpdate.DoRun PkgDir=',PkgDir);
    writeln('TLPLUpdate.DoRun LinksDir=',LinksDir);
  end;

  Packages:=TPackages.create(true);
  Links:=TLinks.create(true);
  try
    ScanPackages(PkgDir,Packages);
    ScanLinks(LinksDir,Links);

    WriteMissingLinks(Packages,Links);
    WriteDeadLinks(Links);
    WriteLinksWithWrongVersion(Packages,Links);

  finally
    Links.Free;
    Packages.Free;
  end;

  // stop program loop
  Terminate;
end;

procedure TLPLUpdate.Error(Msg: string);
begin
  ShowException(Exception.Create(Msg));
end;

procedure TLPLUpdate.ScanPackages(Dir: string; Packages: TPackages);
var
  FileInfo: TSearchRec;
begin
  if FindFirstUTF8(Dir+FileMask,faAnyFile,FileInfo)=0 then
  begin
    repeat
      // skip special files
      if (FileInfo.Name='.') or (FileInfo.Name='..') or (FileInfo.Name='')
      then
        continue;
      if (FileInfo.Attr and faDirectory)>0 then begin
        // scan sub directories too
        ScanPackages(AppendPathDelim(Dir+FileInfo.Name),Packages);
      end else if CompareFileExt(FileInfo.Name,'.lpk',false)=0 then begin
        ScanPackage(Dir+FileInfo.Name,Packages);
      end;
    until FindNextUTF8(FileInfo)<>0;
  end;
  FindCloseUTF8(FileInfo);
end;

procedure TLPLUpdate.ScanPackage(Filename: string; Packages: TPackages);
var
  XMLConfig: TXMLConfig;
  Path: String;
  Pkg: TPackage;
begin
  XMLConfig:=TXMLConfig.Create(Filename);
  try
    Pkg:=TPackage.Create;
    Packages.Add(Pkg);
    Pkg.Filename:=Filename;
    Pkg.Name:=lowercase(ExtractFileNameOnly(Filename));
    Path:='Package/Version/';
    Pkg.Major:=XMLConfig.GetValue(Path+'Major',0);
    Pkg.Minor:=XMLConfig.GetValue(Path+'Minor',0);
    Pkg.Release:=XMLConfig.GetValue(Path+'Release',0);
    Pkg.Build:=XMLConfig.GetValue(Path+'Build',0);
    if Verbose then
      writeln('TLPLUpdate.ScanPackage ',Pkg.Name,'-',Pkg.VersionAsString,' in ',CreateRelativePath(Pkg.Filename,PkgDir));
  finally
    XMLConfig.Free;
  end;
end;

procedure TLPLUpdate.ScanLinks(Dir: string; Links: TLinks);
var
  FileInfo: TSearchRec;
begin
  if FindFirstUTF8(Dir+FileMask,faAnyFile,FileInfo)=0 then
  begin
    repeat
      // skip special files
      if (FileInfo.Name='.') or (FileInfo.Name='..') or (FileInfo.Name='')
      then
        continue;
      if (FileInfo.Attr and faDirectory)>0 then begin
        // skip
      end else if CompareFileExt(FileInfo.Name,'.lpl',false)=0 then begin
        ScanLink(Dir+FileInfo.Name,Links);
      end;
    until FindNextUTF8(FileInfo)<>0;
  end;
  FindCloseUTF8(FileInfo);
end;

procedure TLPLUpdate.ScanLink(Filename: string; Links: TLinks);
const
  LazDirMacro = '$(LazarusDir)';
var
  Link: TLink;
  s: String;
  p: Integer;
  Version: String;
  i: LongInt;
  v: LongInt;
  sl: TStringList;
begin
  Link:=TLink.Create;
  Links.Add(Link);
  Link.Filename:=Filename;
  // for example: name-0.5.lpl
  s:=ExtractFileNameOnly(Filename);
  p:=Pos('-',s);
  if p<1 then
    Error('missing - in  lpl file name: '+Filename);
  // package name
  Link.PkgName:=copy(s,1,p-1);
  if (Link.PkgName='') or (not IsValidIdent(Link.PkgName)) then
    Error('invalid name in lpl file name: '+Filename);
  // package version
  Version:=copy(s,p+1,length(s));
  i:=1;
  repeat
    p:=Pos('.',Version);
    if p=1 then
      Error('invalid version in lpl file name: '+Filename);
    if p=0 then p:=length(s)+1;
    v:=StrToIntDef(copy(Version,1,p-1),-1);
    if v<0 then
      Error('invalid version in lpl file name: '+Filename);
    case i of
    1: Link.Major:=v;
    2: Link.Minor:=v;
    3: Link.Release:=v;
    4: Link.Build:=v;
    end;
    Version:=copy(Version,p+1,length(Version));
    if Version='' then break;
    inc(i);
    if i>4 then
      Error('invalid version in lpl file name: '+Filename)
  until false;
  // read file
  sl:=TStringList.Create;
  try
    sl.LoadFromFile(Filename);
    if sl.Count<1 then
      Error('missing file name in lpl file: '+Filename);
    Link.PkgFilename:=sl[0];
    Link.ExpFilename:=Link.PkgFilename;
    Link.InLazarusDir:=CompareText(copy(Link.PkgFilename,1,length(LazDirMacro)),LazDirMacro)=0;
    if Link.InLazarusDir then
      Link.ExpFilename:=LazarusDir+copy(Link.PkgFilename,length(LazDirMacro)+1,length(Link.PkgFilename));
    Link.ExpFilename:=CleanAndExpandFilename(Link.ExpFilename);
  finally
    sl.Free;
  end;
  if Verbose then
    writeln('TLPLUpdate.ScanLink ',ExtractFileNameOnly(Filename),' in ',Link.PkgFilename);
end;

procedure TLPLUpdate.WriteMissingLinks(Packages: TPackages; Links: TLinks);
// write packages which name is not in the links
var
  i: Integer;
  Pkg: TPackage;
begin
  for i:=0 to Packages.Count-1 do begin
    Pkg:=Packages[i];
    if Links.FindLinkWithName(Pkg.Name)=nil then
      writeln('Missing link ',Pkg.Name+'-'+Pkg.VersionAsString,' in '+CreateRelativePath(Pkg.Filename,PkgDir));
  end;
end;

procedure TLPLUpdate.WriteDeadLinks(Links: TLinks);
// write links that points to non existing files
var
  i: Integer;
  Link: TLink;
begin
  for i:=0 to Links.Count-1 do begin
    Link:=Links[i];
    if not FileExistsUTF8(Link.ExpFilename) then begin
      if not (Quiet and WriteCommands) then
        writeln('Dead link ',ExtractFileNameOnly(Link.Filename),' to missing '+CreateRelativePath(Link.PkgFilename,PkgDir));
      if WriteCommands then begin
        writeln('svn rm ',CreateRelativePath(Link.Filename,LazarusDir));
      end;
    end;
  end;
end;

procedure TLPLUpdate.WriteLinksWithWrongVersion(Packages: TPackages;
  Links: TLinks);
// write links with different version than the lpk files
var
  i: Integer;
  Link: TLink;
  j: Integer;
  Pkg: TPackage;
begin
  for i:=0 to Links.Count-1 do begin
    Link:=Links[i];
    j:=Packages.Count-1;
    while (j>=0) do begin
      Pkg:=Packages[j];
      if CompareFilenames(Link.ExpFilename,Pkg.Filename)=0 then begin
        if (Link.Major<>Pkg.Major)
        or (Link.Minor<>Pkg.Minor)
        or (Link.Release<>Pkg.Release)
        // ignore build
        then
          writeln('Version mismatch link ',ExtractFileNameOnly(Link.Filename),' <> ',Pkg.VersionAsString,' in ',CreateRelativePath(Pkg.Filename,PkgDir));
        break;
      end;
      dec(j);
    end;
    if (j<0) and (FileExistsUTF8(Link.ExpFilename)) then
      Error('package link target not found: '+ExtractFileNameOnly(Link.Filename)+' '+Link.ExpFilename);
  end;
end;

constructor TLPLUpdate.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TLPLUpdate.Destroy;
begin
  inherited Destroy;
end;

procedure TLPLUpdate.WriteHelp;
begin
  writeln;
  writeln('Usage: ',ExeName,' -h');
  writeln;
  writeln('-L <lazarus directory>, --lazarusdir=<dir>');
  writeln('    The lazarus source directory.');
  writeln('    Default is ',GetDefaultLazarusDir);
  writeln;
  writeln('-c, --commands');
  writeln('    Write shell commands to fix issues.');
  writeln;
  writeln('-p <directory of lpk files>, --pkgdir=<dir>');
  writeln('    The directory where to search for lpk files, including sub directories.');
  writeln('    Default is ',GetDefaultPkgDirectory);
  writeln;
  writeln('-l <directory of lpl files> --linksdir=<dir>');
  writeln('    The directory where to search for lpl files.');
  writeln('    Default is ',GetDefaultLinksDirectory);
  writeln;
  writeln('-v, --verbose');
  writeln;
  writeln('-q, --quiet');
  writeln;
end;

function TLPLUpdate.GetDefaultLazarusDir: string;
begin
  if GetEnvironmentVariableUTF8('LAZARUSDIR')<>'' then
    Result:=GetEnvironmentVariableUTF8('LAZARUSDIR')
  else
    Result:=GetCurrentDirUTF8;
  Result:=CleanAndExpandDirectory(Result);
end;

function TLPLUpdate.GetLazarusDir: string;
begin
  if LazarusDir<>'' then
    Result:=LazarusDir
  else
    Result:=GetDefaultLazarusDir;
end;

function TLPLUpdate.GetDefaultPkgDirectory: string;
begin
  Result:=GetLazarusDir;
end;

function TLPLUpdate.GetDefaultLinksDirectory: string;
begin
  Result:=GetLazarusDir+'packager'+PathDelim+'globallinks'+PathDelim;
end;

{ TPackages }

function TPackages.GetPackages(Index: integer): TPackage;
begin
  Result:=TPackage(Items[Index]);
end;

function TPackages.IndexByName(PkgName: string): integer;
begin
  Result:=Count-1;
  while (Result>0) and (CompareText(PkgName,Packages[Result].Name)<>0) do
    dec(Result);
end;

function TPackages.FindByName(PkgName: string): TPackage;
var
  i: LongInt;
begin
  i:=IndexByName(PkgName);
  if i>=0 then
    Result:=Packages[i]
  else
    Result:=nil;
end;

function TPackage.VersionAsString: string;

  procedure Add(var s: string; v: integer; Force: boolean = false);
  begin
    if Force or (v<>0) or (s<>'') then begin
      if s<>'' then s:='.'+s;
      s:=IntToStr(v)+s;
    end;
  end;

begin
  Result:='';
  Add(Result,Build);
  Add(Result,Release);
  Add(Result,Minor);
  Add(Result,Major,true);
end;

{ TLinks }

function TLinks.GetLinks(Index: integer): TLink;
begin
  Result:=TLink(Items[Index]);
end;

function TLinks.FindLinkWithName(PkgName: string): TLink;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Result:=Links[i];
    if CompareText(PkgName,Result.PkgName)=0 then exit;
  end;
  Result:=nil;
end;

var
  Application: TLPLUpdate;

begin
  Application:=TLPLUpdate.Create(nil);
  Application.Run;
  Application.Free;
end.

