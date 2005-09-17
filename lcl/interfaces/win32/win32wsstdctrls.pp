{ $Id$}
{
 *****************************************************************************
 *                            Win32WSStdCtrls.pp                             * 
 *                            ------------------                             * 
 *                                                                           *
 *                                                                           *
 *****************************************************************************

 *****************************************************************************
 *                                                                           *
 *  This file is part of the Lazarus Component Library (LCL)                 *
 *                                                                           *
 *  See the file COPYING.LCL, included in this distribution,                 *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************
}
unit Win32WSStdCtrls;

{$mode objfpc}{$H+}

interface

uses
////////////////////////////////////////////////////
// I M P O R T A N T                                
////////////////////////////////////////////////////
// To get as little as posible circles,
// uncomment only when needed for registration
////////////////////////////////////////////////////
  Classes, StdCtrls, Controls, Graphics, Forms, SysUtils,
////////////////////////////////////////////////////
  WSStdCtrls, WSLCLClasses, Windows, LCLType, 
  Win32Int, Win32Proc, InterfaceBase, Win32WSControls;

type

  { TWin32WSScrollBar }

  TWin32WSScrollBar = class(TWSScrollBar)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
    class procedure SetParams(const AScrollBar: TCustomScrollBar); override;
  end;

  { TWin32WSCustomGroupBox }

  TWin32WSCustomGroupBox = class(TWSCustomGroupBox)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
    class procedure AdaptBounds(const AWinControl: TWinControl;
          var Left, Top, Width, Height: integer; var SuppressMove: boolean); override;
  end;

  { TWin32WSGroupBox }

  TWin32WSGroupBox = class(TWSGroupBox)
  private
  protected
  public
  end;

  { TWin32WSCustomComboBox }

  TWin32WSCustomComboBox = class(TWSCustomComboBox)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
    class procedure AdaptBounds(const AWinControl: TWinControl;
          var Left, Top, Width, Height: integer; var SuppressMove: boolean); override;
    class function  GetSelStart(const ACustomComboBox: TCustomComboBox): integer; override;
    class function  GetSelLength(const ACustomComboBox: TCustomComboBox): integer; override;
    class function  GetItemIndex(const ACustomComboBox: TCustomComboBox): integer; override;
    class function  GetMaxLength(const ACustomComboBox: TCustomComboBox): integer; override;
    class function  GetText(const AWinControl: TWinControl; var AText: string): boolean; override;

    class procedure SetArrowKeysTraverseList(const ACustomComboBox: TCustomComboBox; 
      NewTraverseList: boolean); override;
    class procedure SetSelStart(const ACustomComboBox: TCustomComboBox; NewStart: integer); override;
    class procedure SetSelLength(const ACustomComboBox: TCustomComboBox; NewLength: integer); override;
    class procedure SetItemIndex(const ACustomComboBox: TCustomComboBox; NewIndex: integer); override;
    class procedure SetMaxLength(const ACustomComboBox: TCustomComboBox; NewLength: integer); override;
    class procedure SetStyle(const ACustomComboBox: TCustomComboBox; NewStyle: TComboBoxStyle); override;
    class procedure SetText(const AWinControl: TWinControl; const AText: string); override;
    
    class function  GetItems(const ACustomComboBox: TCustomComboBox): TStrings; override;
    class procedure Sort(const ACustomComboBox: TCustomComboBox; AList: TStrings; IsSorted: boolean); override;
  end;

  { TWin32WSComboBox }

  TWin32WSComboBox = class(TWSComboBox)
  private
  protected
  public
  end;

  { TWin32WSCustomListBox }

  TWin32WSCustomListBox = class(TWSCustomListBox)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
    class function  GetSelCount(const ACustomListBox: TCustomListBox): integer; override;
    class function  GetSelected(const ACustomListBox: TCustomListBox; const AIndex: integer): boolean; override;
    class function  GetStrings(const ACustomListBox: TCustomListBox): TStrings; override;
    class function  GetItemIndex(const ACustomListBox: TCustomListBox): integer; override;
    class function  GetTopIndex(const ACustomListBox: TCustomListBox): integer; override;
    class procedure SelectItem(const ACustomListBox: TCustomListBox; AIndex: integer; ASelected: boolean); override;
    class procedure SetBorder(const ACustomListBox: TCustomListBox); override;
    class procedure SetItemIndex(const ACustomListBox: TCustomListBox; const AIndex: integer); override;
    class procedure SetSelectionMode(const ACustomListBox: TCustomListBox; const AExtendedSelect,
      AMultiSelect: boolean); override;
    class procedure SetStyle(const ACustomListBox: TCustomListBox); override;
    class procedure SetSorted(const ACustomListBox: TCustomListBox; AList: TStrings; ASorted: boolean); override;
    class procedure SetTopIndex(const ACustomListBox: TCustomListBox; const NewTopIndex: integer); override;
  end;
    
  { TWin32WSListBox }

  TWin32WSListBox = class(TWSListBox)
  private
  protected
  public
  end;

  { TWin32WSCustomEdit }

  TWin32WSCustomEdit = class(TWSCustomEdit)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
    class function  GetSelStart(const ACustomEdit: TCustomEdit): integer; override;
    class function  GetSelLength(const ACustomEdit: TCustomEdit): integer; override;
    class function  GetMaxLength(const ACustomEdit: TCustomEdit): integer; {override;}
    class function  GetText(const AWinControl: TWinControl; var AText: string): boolean; override;

    class procedure SetCharCase(const ACustomEdit: TCustomEdit; NewCase: TEditCharCase); override;
    class procedure SetEchoMode(const ACustomEdit: TCustomEdit; NewMode: TEchoMode); override;
    class procedure SetMaxLength(const ACustomEdit: TCustomEdit; NewLength: integer); override;
    class procedure SetPasswordChar(const ACustomEdit: TCustomEdit; NewChar: char); override;
    class procedure SetReadOnly(const ACustomEdit: TCustomEdit; NewReadOnly: boolean); override;
    class procedure SetSelStart(const ACustomEdit: TCustomEdit; NewStart: integer); override;
    class procedure SetSelLength(const ACustomEdit: TCustomEdit; NewLength: integer); override;
  end;

  { TWin32WSCustomMemo }

  TWin32WSCustomMemo = class(TWSCustomMemo)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
    class function  GetStrings(const ACustomMemo: TCustomMemo): TStrings; override;
    class procedure AppendText(const ACustomMemo: TCustomMemo; const AText: string); override;
    class procedure SetScrollbars(const ACustomMemo: TCustomMemo; const NewScrollbars: TScrollStyle); override;
    class procedure SetText(const AWinControl: TWinControl; const AText: string); override;
    class procedure SetWordWrap(const ACustomMemo: TCustomMemo; const NewWordWrap: boolean); override;
  end;

  { TWin32WSEdit }

  TWin32WSEdit = class(TWSEdit)
  private
  protected
  public
  end;

  { TWin32WSMemo }

  TWin32WSMemo = class(TWSMemo)
  private
  protected
  public
  end;

  { TWin32WSCustomStaticText }

  TWin32WSCustomStaticText = class(TWSCustomStaticText)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
    class procedure SetAlignment(const ACustomStaticText: TCustomStaticText; const NewAlignment: TAlignment); override;
  end;

  { TWin32WSStaticText }

  TWin32WSStaticText = class(TWSStaticText)
  private
  protected
  public
  end;

  { TWin32WSButtonControl }

  TWin32WSButtonControl = class(TWSButtonControl)
  private
  protected
  public
  end;

  { TWin32WSCustomCheckBox }

  TWin32WSCustomCheckBox = class(TWSCustomCheckBox)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
    class function  RetrieveState(const ACustomCheckBox: TCustomCheckBox): TCheckBoxState; override;
    class procedure SetShortCut(const ACustomCheckBox: TCustomCheckBox;
          const OldShortCut, NewShortCut: TShortCut); override;
    class procedure SetState(const ACustomCheckBox: TCustomCheckBox; const NewState: TCheckBoxState); override;
  end;

  { TWin32WSCheckBox }

  TWin32WSCheckBox = class(TWSCheckBox)
  private
  protected
  public
  end;

  { TWin32WSToggleBox }

  TWin32WSToggleBox = class(TWSToggleBox)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
  end;

  { TWin32WSRadioButton }

  TWin32WSRadioButton = class(TWSRadioButton)
  private
  protected
  public
    class function  CreateHandle(const AWinControl: TWinControl;
          const AParams: TCreateParams): HWND; override;
  end;

{ useful helper functions }

function  EditGetSelStart(WinHandle: HWND): integer;
function  EditGetSelLength(WinHandle: HWND): integer;
procedure EditSetSelStart(WinHandle: HWND; NewStart: integer);
procedure EditSetSelLength(WinHandle: HWND; NewLength: integer);

{$DEFINE MEMOHEADER}
{$I win32memostrings.inc}
{$UNDEF MEMOHEADER}

implementation

{$I win32memostrings.inc}

{ TWin32WSScrollBar }

function TWin32WSScrollBar.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    case TScrollBar(AWinControl).Kind of
      sbHorizontal:
        Flags := Flags or SBS_HORZ;
      sbVertical:
        Flags := Flags or SBS_VERT;
    end;
    pClassName := 'SCROLLBAR';
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  Result := Params.Window;
end;

procedure TWin32WSScrollBar.SetParams(const AScrollBar: TCustomScrollBar);
begin
  with AScrollBar do
  begin
    SendMessage(Handle, SBM_SETRANGE, Min, Max);
    SendMessage(Handle, SBM_SETPOS, Position, LPARAM(true));
    case Kind of
      sbHorizontal:
        SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or SBS_HORZ);
      sbVertical:
        SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or SBS_VERT);
    end;
    Assert(False, 'Trace:TODO: [TWin32WSScrollBar.SetParams] Set up step and page increments for csScrollBar');
  end;
end;

{ TWin32WSCustomGroupBox }

function GroupBoxPanelWindowProc(Window: HWnd; Msg: UInt; WParam: Windows.WParam;
    LParam: Windows.LParam): LResult; stdcall;
begin
  // handle paint messages for theming
  case Msg of
    WM_ERASEBKGND, WM_NCPAINT, WM_PAINT, WM_CTLCOLORMSGBOX..WM_CTLCOLORSTATIC:
    begin
      Result := WindowProc(Window, Msg, WParam, LParam);
    end;
  else
    Result := CallDefaultWindowProc(Window, Msg, WParam, LParam);
  end;
end;

function TWin32WSCustomGroupBox.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    if TWin32WidgetSet(WidgetSet).ThemesActive and (AWinControl.Parent <> nil) and 
      (AWinControl.Parent is TCustomGroupBox) then
    begin
      // the parent of this groupbox is another groupbox: there is a bug in 
      // drawing the caption in that case, the caption of the child groupbox
      // is drawn in system font, make an intermediate "ParentPanel", then
      // the bug is hidden. Use 'ParentPanel' property of groupbox window
      // to determine reference to this parent panel
      // do not use 'ParentPanel' property for other controls!
      Buddy := CreateWindowEx(0, @ClsName, nil, WS_CHILD or WS_CLIPCHILDREN or 
        WS_CLIPSIBLINGS or (Flags and WS_VISIBLE), 
        Left, Top, Width, Height, Parent, 0, HInstance, nil);
      Left := 0;
      Top := 0;
      Flags := Flags or WS_VISIBLE;
      // set P(aint)WinControl, for paint message to retrieve information
      // about wincontrol (hack)
      // allocate windowinfo record ourselves, we do not call WindowInitBuddy
      BuddyWindowInfo := AllocWindowInfo(Buddy);
      BuddyWindowInfo^.PWinControl := AWinControl;
      if GetWindowInfo(Parent)^.hasTabParent then
        BuddyWindowInfo^.hasTabParent := true;
      Parent := Buddy;
    end;
    pClassName := 'BUTTON';
    WindowTitle := StrCaption;
    Flags := Flags Or BS_GROUPBOX;
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  // handle winxp panel hack
  with Params do
  begin
    if Buddy <> 0 then
    begin
      WindowInfo^.ParentPanel := Buddy;
      // no need to subclass this parentpanel
      Buddy := 0;
    end;
  end;
  // if themed but does not have tabpage as parent
  // remember we are a groupbox in need of erasebackground hack
  if TWin32WidgetSet(WidgetSet).ThemesActive 
      and not Params.WindowInfo^.hasTabParent then
    Params.WindowInfo^.isGroupBox := true;
  AWinControl.InvalidateClientRectCache(true);
  Result := Params.Window;
end;

procedure TWin32WSCustomGroupBox.AdaptBounds(const AWinControl: TWinControl;
  var Left, Top, Width, Height: integer; var SuppressMove: boolean);
var
  WinHandle, BuddyHandle: HWND;
begin
  WinHandle := AWinControl.Handle;
  // check if we have a ``container'', if so, move that
  BuddyHandle := GetWindowInfo(WinHandle)^.ParentPanel;
  if BuddyHandle <> 0 then
  begin
    MoveWindow(BuddyHandle, Left, Top, Width, Height, false);
    Left := 0;
    Top := 0;
  end;
end;
  
{ TWin32WSCustomListBox }

function TWin32WSCustomListBox.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    with TCustomListBox(AWinControl) do
    begin
      if Sorted then
        Flags := Flags or LBS_SORT;
      if MultiSelect then
        if ExtendedSelect then
          Flags := Flags or LBS_EXTENDEDSEL
        else
          Flags := Flags or LBS_MULTIPLESEL;
      if AWinControl.FCompStyle = csCheckListBox then
        Flags := Flags or LBS_OWNERDRAWFIXED
      else case Style of
        lbOwnerDrawFixed: Flags := Flags or LBS_OWNERDRAWFIXED;
        lbOwnerDrawVariable: Flags := Flags or LBS_OWNERDRAWVARIABLE;
      end;
    end;
    FlagsEx := FlagsEx or WS_EX_CLIENTEDGE;
    pClassName := 'LISTBOX';
    Flags := Flags or (WS_VSCROLL or LBS_NOINTEGRALHEIGHT or LBS_HASSTRINGS or
                       LBS_NOTIFY);
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  // listbox is not a transparent control -> no need for parentpainting
  Params.WindowInfo^.hasTabParent := false;
  Result := Params.Window;
end;

function  TWin32WSCustomListBox.GetItemIndex(const ACustomListBox: TCustomListBox): integer;
begin
  Result := SendMessage(ACustomListBox.Handle, LB_GETCURSEL, 0, 0);
  if Result = LB_ERR then
  begin
    Assert(false, 'Trace:[TWin32WSCustomListBox.GetItemIndex] could not retrieve itemindex, try selecting an item first');
    Result := -1;
  end;
end;

function  TWin32WSCustomListBox.GetSelCount(const ACustomListBox: TCustomListBox): integer;
begin
  // GetSelCount only works for multiple-selection listboxes
  if ACustomListBox.MultiSelect then
    Result := Windows.SendMessage(ACustomListBox.Handle, LB_GETSELCOUNT, 0, 0)
  else begin
    if Windows.SendMessage(ACustomListBox.Handle, LB_GETCURSEL, 0, 0) = LB_ERR then
      Result := 0
    else
      Result := 1;
  end;
end;

function  TWin32WSCustomListBox.GetSelected(const ACustomListBox: TCustomListBox; const AIndex: integer): boolean;
var
  WindowInfo: PWindowInfo;
  winHandle: HWND;
begin
  winHandle := ACustomListBox.Handle;
  WindowInfo := GetWindowInfo(winHandle);
  // if we're handling a WM_DRAWITEM, then LB_GETSEL is not reliable, check stored info
  if (WindowInfo^.DrawItemIndex <> -1) and (WindowInfo^.DrawItemIndex = AIndex) then
    Result := WindowInfo^.DrawItemSelected
  else
    Result := Windows.SendMessage(winHandle, LB_GETSEL, Windows.WParam(AIndex), 0) > 0;
end;

function  TWin32WSCustomListBox.GetStrings(const ACustomListBox: TCustomListBox): TStrings;
var
  Handle: HWND;
begin
  Handle := ACustomListBox.Handle;
  Result := TWin32ListStringList.Create(Handle, ACustomListBox);
  GetWindowInfo(Handle)^.List := Result;
end;

function  TWin32WSCustomListBox.GetTopIndex(const ACustomListBox: TCustomListBox): integer;
begin
  Result:=Windows.SendMessage(ACustomListBox.Handle, LB_GETTOPINDEX, 0, 0);
end;

procedure TWin32WSCustomListBox.SelectItem(const ACustomListBox: TCustomListBox; AIndex: integer; ASelected: boolean);
begin
  if ACustomListBox.MultiSelect then
    Windows.SendMessage(ACustomListBox.Handle, LB_SETSEL, 
      Windows.WParam(ASelected), Windows.LParam(AIndex))
  else
  if ASelected then
    SetItemIndex(ACustomListBox, AIndex)
  else
    SetItemIndex(ACustomListBox, -1);
end;

procedure TWin32WSCustomListBox.SetBorder(const ACustomListBox: TCustomListBox);
var
  Handle: HWND;
  StyleEx: dword;
begin
  Handle := ACustomListBox.Handle;
  StyleEx := GetWindowLong(Handle, GWL_EXSTYLE);
  if ACustomListBox.BorderStyle = TBorderStyle(bsSingle) Then
    StyleEx := StyleEx or WS_EX_CLIENTEDGE
  else
    StyleEx := StyleEx and not WS_EX_CLIENTEDGE;
  SetWindowLong(Handle, GWL_EXSTYLE, StyleEx);
end;

procedure TWin32WSCustomListBox.SetItemIndex(const ACustomListBox: TCustomListBox; const AIndex: integer);
var
  Handle: HWND;
begin
  Handle := ACustomListBox.Handle;
  if ACustomListBox.MultiSelect then
  begin
    // deselect all items first
    Windows.SendMessage(Handle, LB_SETSEL, Windows.WParam(false), -1);
    if AIndex >= 0 then
      Windows.SendMessage(Handle, LB_SETSEL, Windows.WParam(true), Windows.LParam(AIndex));
  end else
    Windows.SendMessage(Handle, LB_SETCURSEL, Windows.WParam(AIndex), 0);

  // windows does not send selection changed notify message
  ACustomListBox.IntfSelectionChanged;
end;

procedure TWin32WSCustomListBox.SetSelectionMode(const ACustomListBox: TCustomListBox;
  const AExtendedSelect, AMultiSelect: boolean);
begin
  RecreateWnd(ACustomListBox);
end;

procedure TWin32WSCustomListBox.SetStyle(const ACustomListBox: TCustomListBox);
begin
  // The listbox styles can't be updated, so recreate the listbox
  RecreateWnd(ACustomListBox);
end;

procedure TWin32WSCustomListBox.SetSorted(const ACustomListBox: TCustomListBox; AList: TStrings; ASorted: boolean);
begin
  TWin32ListStringList(AList).Sorted := ASorted;
end;

procedure TWin32WSCustomListBox.SetTopIndex(const ACustomListBox: TCustomListBox; const NewTopIndex: integer);
begin
  Windows.SendMessage(ACustomListBox.Handle, LB_SETTOPINDEX, NewTopIndex, 0);
end;

{ TWin32WSCustomComboBox }

const
  ComboBoxStyles: array[TComboBoxStyle] of Integer = (
    CBS_DROPDOWN, CBS_SIMPLE, CBS_DROPDOWNLIST,
    CBS_DROPDOWNLIST or CBS_OWNERDRAWFIXED,
    CBS_DROPDOWNLIST or CBS_OWNERDRAWVARIABLE);
  ComboBoxStylesMask = CBS_DROPDOWN or CBS_DROPDOWN or CBS_DROPDOWNLIST or
    CBS_OWNERDRAWFIXED or CBS_OWNERDRAWVARIABLE;

function TWin32WSCustomComboBox.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    Flags := Flags or ComboBoxStyles[TCustomComboBox(AWinControl).Style];
    If TComboBox(AWinControl).Sorted Then
      Flags:= Flags or CBS_SORT;
    pClassName := 'COMBOBOX';
    Flags := Flags or WS_VSCROLL or CBS_AUTOHSCROLL or CBS_HASSTRINGS;
    SubClassWndProc := @ComboBoxWindowProc;
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  // combobox is not a transparent control -> no need for parentpainting
  Params.WindowInfo^.hasTabParent := false;

  // get edit window within
  with Params do
  begin
    Buddy := Windows.GetTopWindow(Window);
    // If the style is CBS_DROPDOWNLIST, GetTopWindow returns null,
    // because the combobox has no edit in that case.
    if Buddy<>HWND(nil) then begin
      SubClassWndProc := @WindowProc;
      WindowCreateInitBuddy(AWinControl, Params);
      BuddyWindowInfo^.isChildEdit := true;
      BuddyWindowInfo^.isComboEdit := true;
    end else BuddyWindowInfo:=nil;
  end;
  Result := Params.Window;
end;

procedure TWin32WSCustomComboBox.AdaptBounds(const AWinControl: TWinControl;
  var Left, Top, Width, Height: integer; var SuppressMove: boolean);
var
  WinHandle: HWND;
  StringList: TWin32ComboBoxStringList;
begin
  WinHandle := AWinControl.Handle;
  StringList := TWin32ComboBoxStringList(GetWindowInfo(WinHandle)^.List);
  if StringList <> nil then
    Height := StringList.ComboHeight;
end;

function  TWin32WSCustomComboBox.GetSelStart(const ACustomComboBox: TCustomComboBox): integer;
begin
  SendMessage(ACustomComboBox.Handle, CB_GETEDITSEL, Windows.WPARAM(@Result), Windows.LPARAM(nil));
end;

function  TWin32WSCustomComboBox.GetSelLength(const ACustomComboBox: TCustomComboBox): integer;
var
  startPos, endPos: dword;
begin
  SendMessage(ACustomComboBox.Handle, CB_GETEDITSEL, Windows.WPARAM(@startPos), Windows.LPARAM(@endPos));
  Result := endPos - startPos;
end;

procedure TWin32WSCustomComboBox.SetStyle(const ACustomComboBox: TCustomComboBox; NewStyle: TComboBoxStyle);
var
  CurrentStyle: Integer;
begin
  CurrentStyle := GetWindowLong(ACustomComboBox.Handle, GWL_STYLE);
  if (CurrentStyle and ComboBoxStylesMask)=
    ComboBoxStyles[TCustomComboBox(ACustomComboBox).Style] then exit;

  RecreateWnd(ACustomComboBox);
end;

function  TWin32WSCustomComboBox.GetItemIndex(const ACustomComboBox: TCustomComboBox): integer;
begin
  Result := SendMessage(ACustomComboBox.Handle, CB_GETCURSEL, 0, 0);
  if Result = LB_ERR Then
  Begin
    Assert(False, 'Trace:[TWin32WidgetSet.IntSendMessage3] Could not retrieve item index '+
        'via LM_GETITEMINDEX; try selecting an item first');
    Result := -1;
  End;
end;

function  TWin32WSCustomComboBox.GetMaxLength(const ACustomComboBox: TCustomComboBox): integer;
begin
  Result := GetWindowInfo(ACustomComboBox.Handle)^.MaxLength;
end;

function  TWin32WSCustomComboBox.GetText(const AWinControl: TWinControl; var AText: string): boolean;
var
  Handle: HWND;
  CapLen: dword;
  Caption: PChar;
begin
  Result := AWinControl.HandleAllocated;
  if not Result then
    exit;
  AText := '';
  Handle := AWinControl.Handle;
  // TODO: this can be made shorter probably, using SetLength(AText, ...)
  // + 1 = terminating null character
  CapLen := Windows.SendMessage(Handle, WM_GETTEXTLENGTH, 0, 0) + 1;
  Caption := StrAlloc(CapLen);
  Windows.SendMessage(Handle, WM_GETTEXT, CapLen, LPARAM(Caption));
  AText := StrPas(Caption);
  StrDispose(Caption);
end;

procedure TWin32WSCustomComboBox.SetArrowKeysTraverseList(const ACustomComboBox: TCustomComboBox; 
  NewTraverseList: boolean);
begin
  // TODO: implement me?
end;

procedure TWin32WSCustomComboBox.SetSelStart(const ACustomComboBox: TCustomComboBox; NewStart: integer);
begin
  SendMessage(ACustomComboBox.Handle, CB_SETEDITSEL, 0, MakeLParam(NewStart, NewStart));
end;

procedure TWin32WSCustomComboBox.SetSelLength(const ACustomComboBox: TCustomComboBox; NewLength: integer);
var
  startpos, endpos: integer;
  winhandle: HWND;
begin
  winhandle := ACustomComboBox.Handle;
  SendMessage(winhandle, CB_GETEDITSEL, Windows.WParam(@startpos), Windows.LParam(@endpos));
  endpos := startpos + NewLength;
  SendMessage(winhandle, CB_SETEDITSEL, 0, MakeLParam(startpos, endpos));
end;

procedure TWin32WSCustomComboBox.SetItemIndex(const ACustomComboBox: TCustomComboBox; NewIndex: integer);
begin
  SendMessage(ACustomComboBox.Handle, CB_SETCURSEL, Windows.WParam(NewIndex), 0);
end;

procedure TWin32WSCustomComboBox.SetMaxLength(const ACustomComboBox: TCustomComboBox; NewLength: integer);
var
  winhandle: HWND;
begin
  winhandle := ACustomComboBox.Handle;
  SendMessage(winhandle, CB_LIMITTEXT, NewLength, 0);
  GetWindowInfo(winhandle)^.MaxLength := NewLength;
end;

procedure TWin32WSCustomComboBox.SetText(const AWinControl: TWinControl; const AText: string);
var
  Handle: HWND;
begin
  Assert(False, Format('Trace:TWin32WSCustomComboBox.SetText --> %S', [AText]));
  Handle := AWinControl.Handle;
  if TCustomComboBox(AWinControl).Style = csDropDownList then
    Windows.SendMessage(Handle, CB_SELECTSTRING, -1, LPARAM(PChar(AText)))
  else
    Windows.SendMessage(Handle, WM_SETTEXT, 0, LPARAM(PChar(AText)));
end;

function  TWin32WSCustomComboBox.GetItems(const ACustomComboBox: TCustomComboBox): TStrings;
var
  winhandle: HWND;
begin
  winhandle := ACustomComboBox.Handle;
  Result := TWin32ComboBoxStringList.Create(winhandle, ACustomComboBox);
  GetWindowInfo(winhandle)^.List := Result;
end;

procedure TWin32WSCustomComboBox.Sort(const ACustomComboBox: TCustomComboBox; AList: TStrings; IsSorted: boolean);
begin
  TWin32ListStringList(AList).Sorted := IsSorted;
end;

{ TWin32WSCustomEdit helper functions }

function EditGetSelStart(WinHandle: HWND): integer;
begin
  Windows.SendMessage(WinHandle, EM_GETSEL, Windows.WPARAM(@Result), 0);
end;

function EditGetSelLength(WinHandle: HWND): integer;
var
  startpos, endpos: integer;
begin
  Windows.SendMessage(WinHandle, EM_GETSEL, Windows.WPARAM(@startpos), Windows.LPARAM(@endpos));
  Result := endpos - startpos;
end;

procedure EditSetSelStart(WinHandle: HWND; NewStart: integer);
begin
  Windows.SendMessage(WinHandle, EM_SETSEL, Windows.WParam(NewStart), Windows.LParam(NewStart));
  // scroll caret into view
  Windows.SendMessage(WinHandle, EM_SCROLLCARET, 0, 0);
end;

procedure EditSetSelLength(WinHandle: HWND; NewLength: integer);
var
  startpos, endpos: integer;
begin
  Windows.SendMessage(WinHandle, EM_GETSEL, Windows.WParam(@startpos), Windows.LParam(@endpos));
  endpos := startpos + NewLength;
  Windows.SendMessage(WinHandle, EM_SETSEL, Windows.WParam(startpos), Windows.LParam(endpos));
end;

{ TWin32WSCustomEdit }

function TWin32WSCustomEdit.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    if (AWinControl is TCustomEdit) then
      if TCustomEdit(AWinControl).BorderStyle=bsSingle then
    FlagsEx := FlagsEx or WS_EX_CLIENTEDGE;
    pClassName := 'EDIT';
    WindowTitle := StrCaption;
    Flags := Flags or ES_AUTOHSCROLL;
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  // edit is not a transparent control -> no need for parentpainting
  Params.WindowInfo^.hasTabParent := false;
  Result := Params.Window;
end;

function  TWin32WSCustomEdit.GetSelStart(const ACustomEdit: TCustomEdit): integer;
begin
  Result := EditGetSelStart(ACustomEdit.Handle);
end;

function  TWin32WSCustomEdit.GetSelLength(const ACustomEdit: TCustomEdit): integer;
begin
  Result := EditGetSelLength(ACustomEdit.Handle);
end;

function  TWin32WSCustomEdit.GetMaxLength(const ACustomEdit: TCustomEdit): integer;
begin
  Result := GetWindowInfo(ACustomEdit.Handle)^.MaxLength;
end;

function  TWin32WSCustomEdit.GetText(const AWinControl: TWinControl; var AText: string): boolean;
var
  CapLen: dword;
  Caption: PChar;
  Handle: HWND;
begin
  Result := AWinControl.HandleAllocated;
  if not Result then
    exit;
  AText := '';
  Handle := AWinControl.Handle;
  // TODO: this can be made shorter probably, using SetLength(AText, ...)
  CapLen := GetWindowTextLength(Handle);
  Caption := StrAlloc(CapLen + 1);
  GetWindowText(Handle, Caption, CapLen + 1);
  AText := StrPas(Caption);
  StrDispose(Caption);
end;

procedure TWin32WSCustomEdit.SetCharCase(const ACustomEdit: TCustomEdit; NewCase: TEditCharCase);
const
  EditStyles: array[TEditCharCase] of integer = (0, ES_UPPERCASE, ES_LOWERCASE);
  EditStyleMask = ES_UPPERCASE or ES_LOWERCASE;
begin
  UpdateWindowStyle(ACustomEdit.Handle, EditStyles[NewCase], EditStyleMask);
end;

procedure TWin32WSCustomEdit.SetEchoMode(const ACustomEdit: TCustomEdit; NewMode: TEchoMode);
begin
end;

procedure TWin32WSCustomEdit.SetMaxLength(const ACustomEdit: TCustomEdit; NewLength: integer);
var
  winhandle: HWND;
begin
  winhandle := ACustomEdit.Handle;
  SendMessage(winhandle, EM_LIMITTEXT, NewLength, 0);
  GetWindowInfo(winhandle)^.MaxLength := NewLength;
end;

procedure TWin32WSCustomEdit.SetPasswordChar(const ACustomEdit: TCustomEdit; NewChar: char);
begin
  SendMessage(ACustomEdit.Handle, EM_SETPASSWORDCHAR, WParam(NewChar), 0);
end;

procedure TWin32WSCustomEdit.SetReadOnly(const ACustomEdit: TCustomEdit; NewReadOnly: boolean);
begin
  Windows.SendMessage(ACustomEdit.Handle, EM_SETREADONLY, Windows.WPARAM(NewReadOnly), 0);
end;

procedure TWin32WSCustomEdit.SetSelStart(const ACustomEdit: TCustomEdit; NewStart: integer);
begin
  EditSetSelStart(ACustomEdit.Handle, NewStart);
end;

procedure TWin32WSCustomEdit.SetSelLength(const ACustomEdit: TCustomEdit; NewLength: integer);
begin
  EditSetSelLength(ACustomEdit.Handle, NewLength);
end;

{ TWin32WSCustomMemo }

function TWin32WSCustomMemo.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    Flags := Flags or ES_AUTOVSCROLL or ES_MULTILINE or ES_WANTRETURN;
    if TCustomMemo(AWinControl).ReadOnly then
      Flags := Flags or ES_READONLY;
    case TCustomMemo(AWinControl).ScrollBars of
      ssHorizontal, ssAutoHorizontal:
        Flags := Flags or WS_HSCROLL;
      ssVertical, ssAutoVertical:
        Flags := Flags or WS_VSCROLL;
      ssBoth, ssAutoBoth:
        Flags := Flags or WS_HSCROLL or WS_VSCROLL;
    end;
    if TCustomMemo(AWinControl).WordWrap then
      Flags := Flags and not WS_HSCROLL
    else
      Flags := Flags or ES_AUTOHSCROLL;
    FlagsEx := FlagsEx or WS_EX_CLIENTEDGE;
    pClassName := 'EDIT';
    WindowTitle := StrCaption;
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  // memo is not a transparent control -> no need for parentpainting
  Params.WindowInfo^.hasTabParent := false;
  Result := Params.Window;
end;

function TWin32WSCustomMemo.GetStrings(const ACustomMemo: TCustomMemo
  ): TStrings;
begin
  Result:=TWin32MemoStrings.Create(ACustomMemo.Handle, ACustomMemo)
end;

procedure TWin32WSCustomMemo.AppendText(const ACustomMemo: TCustomMemo; const AText: string);
var
  S: string;
begin
  if Length(AText) > 0 then 
  begin
    GetText(ACustomMemo, S);
    S := S + AText;
    SetText(ACustomMemo, S);
  end;
end;

procedure TWin32WSCustomMemo.SetScrollbars(const ACustomMemo: TCustomMemo; const NewScrollbars: TScrollStyle);
begin
  // TODO: check if can be done without recreation
  RecreateWnd(ACustomMemo);
end;

procedure TWin32WSCustomMemo.SetText(const AWinControl: TWinControl; const AText: string);
begin
  SendMessage(AWinControl.Handle, WM_SETTEXT, 0, LPARAM(PChar(AText)));
end;

procedure TWin32WSCustomMemo.SetWordWrap(const ACustomMemo: TCustomMemo; const NewWordWrap: boolean);
begin
  // TODO: check if can be done without recreation
  RecreateWnd(ACustomMemo);
end;

{ TWin32WSCustomStaticText }

const
  AlignmentToStaticTextFlags: array[TAlignment] of dword = (SS_LEFT, SS_RIGHT, SS_CENTER);

function CalcStaticTextFlags(const Alignment: TAlignment): dword;
begin
  Result := AlignmentToStaticTextFlags[Alignment];
end;

function TWin32WSCustomStaticText.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    pClassName := 'STATIC';
    WindowTitle := StrCaption;
    Flags := Flags or CalcStaticTextFlags(TCustomStaticText(AWinControl).Alignment);
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  Result := Params.Window;
end;

procedure TWin32WSCustomStaticText.SetAlignment(const ACustomStaticText: TCustomStaticText; const NewAlignment: TAlignment);
begin
  // can not apply on the fly: needs window recreate
  RecreateWnd(ACustomStaticText);
end;

{ TWin32WSCustomCheckBox }

function TWin32WSCustomCheckBox.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    pClassName := 'BUTTON';
    WindowTitle := StrCaption;
    if TCustomCheckBox(AWinControl).AllowGrayed then
      Flags := Flags Or BS_AUTO3STATE
    else
      Flags := Flags Or BS_AUTOCHECKBOX;
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  Result := Params.Window;
end;

function  TWin32WSCustomCheckBox.RetrieveState(const ACustomCheckBox: TCustomCheckBox): TCheckBoxState;
begin
  case SendMessage(ACustomCheckBox.Handle, BM_GETCHECK, 0, 0) of
    BST_CHECKED:       Result := cbChecked;
    BST_INDETERMINATE: Result := cbGrayed;
  else
    {BST_UNCHECKED:}   Result := cbUnChecked;
  end;
end;

procedure TWin32WSCustomCheckBox.SetShortCut(const ACustomCheckBox: TCustomCheckBox;
  const OldShortCut, NewShortCut: TShortCut);
begin
  // TODO: implement me!
end;

procedure TWin32WSCustomCheckBox.SetState(const ACustomCheckBox: TCustomCheckBox; const NewState: TCheckBoxState);
var
  Flags: WPARAM;
begin
  case NewState of
    cbChecked: Flags := Windows.WParam(BST_CHECKED);
    cbUnchecked: Flags := Windows.WParam(BST_UNCHECKED);
  else
    Flags := Windows.WParam(BST_INDETERMINATE);
  end;
  Windows.SendMessage(ACustomCheckBox.Handle, BM_SETCHECK, Flags, 0);
end;

{ TWin32WSToggleBox }

function TWin32WSToggleBox.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    pClassName := 'BUTTON';
    WindowTitle := StrCaption;
    Flags := Flags or BS_AUTOCHECKBOX or BS_PUSHLIKE;
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  Result := Params.Window;
end;


{ TWin32WSRadioButton }

function TWin32WSRadioButton.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
var
  Params: TCreateWindowExParams;
begin
  // general initialization of Params
  PrepareCreateWindow(AWinControl, Params);
  // customization of Params
  with Params do
  begin
    pClassName := 'BUTTON';
    WindowTitle := StrCaption;
    // BS_AUTORADIOBUTTON may hang the application,
    // if the radiobuttons are not consecutive controls.
    Flags := Flags Or BS_RADIOBUTTON;
  end;
  // create window
  FinishCreateWindow(AWinControl, Params, false);
  Result := Params.Window;
end;



initialization

////////////////////////////////////////////////////
// I M P O R T A N T
////////////////////////////////////////////////////
// To improve speed, register only classes
// which actually implement something
////////////////////////////////////////////////////
  RegisterWSComponent(TScrollBar, TWin32WSScrollBar);
  RegisterWSComponent(TCustomGroupBox, TWin32WSCustomGroupBox);
//  RegisterWSComponent(TGroupBox, TWin32WSGroupBox);
  RegisterWSComponent(TCustomComboBox, TWin32WSCustomComboBox);
//  RegisterWSComponent(TComboBox, TWin32WSComboBox);
  RegisterWSComponent(TCustomListBox, TWin32WSCustomListBox);
//  RegisterWSComponent(TListBox, TWin32WSListBox);
  RegisterWSComponent(TCustomEdit, TWin32WSCustomEdit);
  RegisterWSComponent(TCustomMemo, TWin32WSCustomMemo);
//  RegisterWSComponent(TEdit, TWin32WSEdit);
//  RegisterWSComponent(TMemo, TWin32WSMemo);
//  RegisterWSComponent(TButtonControl, TWin32WSButtonControl);
  RegisterWSComponent(TCustomCheckBox, TWin32WSCustomCheckBox);
//  RegisterWSComponent(TCheckBox, TWin32WSCheckBox);
//  RegisterWSComponent(TCheckBox, TWin32WSCheckBox);
  RegisterWSComponent(TToggleBox, TWin32WSToggleBox);
  RegisterWSComponent(TRadioButton, TWin32WSRadioButton);
  RegisterWSComponent(TCustomStaticText, TWin32WSCustomStaticText);
//  RegisterWSComponent(TStaticText, TWin32WSStaticText);
////////////////////////////////////////////////////
end.
