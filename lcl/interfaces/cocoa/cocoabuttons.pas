{ $Id: $}
{                  --------------------------------------------
                  cocoabuttons.pas  -  Cocoa internal classes
                  --------------------------------------------

 This unit contains the private classhierarchy for the Cocoa implemetations

 *****************************************************************************
  This file is part of the Lazarus Component Library (LCL)

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit CocoaButtons;

{$mode objfpc}{$H+}
{$modeswitch objectivec1}
{$modeswitch objectivec2}
{$interfaces corba}

interface

uses
  // rtl+ftl
  Types, Classes, SysUtils,
  CGGeometry,
  // Libs
  MacOSAll, CocoaAll, CocoaUtils, CocoaGDIObjects,
  cocoa_extra, CocoaPrivate
  // LCL
  ,Graphics;


type

  { IButtonCallback }

  IButtonCallback = interface(ICommonCallback)
    procedure ButtonClick;
  end;

  { TCocoaButton }

  TCocoaButton = objcclass(NSButton)
  protected
    procedure actionButtonClick(sender: NSObject); message 'actionButtonClick:';
    procedure boundsDidChange(sender: NSNotification); message 'boundsDidChange:';
    procedure frameDidChange(sender: NSNotification); message 'frameDidChange:';
  public
    callback: IButtonCallback;
    Glyph: TBitmap;

    smallHeight: integer;
    miniHeight: integer;
    adjustFontToControlSize: Boolean;
    procedure dealloc; override;
    function initWithFrame(frameRect: NSRect): id; override;
    function acceptsFirstResponder: Boolean; override;
    function becomeFirstResponder: Boolean; override;
    function resignFirstResponder: Boolean; override;
    procedure drawRect(dirtyRect: NSRect); override;
    function lclGetCallback: ICommonCallback; override;
    procedure lclClearCallback; override;
    // keyboard
    procedure keyDown(event: NSEvent); override;
    procedure keyUp(event: NSEvent); override;

    // mouse
    procedure mouseDown(event: NSEvent); override;
    procedure mouseUp(event: NSEvent); override;
    procedure rightMouseDown(event: NSEvent); override;
    procedure rightMouseUp(event: NSEvent); override;
    procedure otherMouseDown(event: NSEvent); override;
    procedure otherMouseUp(event: NSEvent); override;

    procedure mouseDragged(event: NSEvent); override;
    procedure mouseEntered(event: NSEvent); override;
    procedure mouseExited(event: NSEvent); override;
    procedure mouseMoved(event: NSEvent); override;
    procedure resetCursorRects; override;
    // lcl overrides
    function lclIsHandle: Boolean; override;
    procedure lclSetFrame(const r: TRect); override;
    // cocoa
    procedure setState(astate: NSInteger); override;
  end;

implementation

{ TCocoaButton }

function TCocoaButton.lclIsHandle: Boolean;
begin
  Result := True;
end;

procedure TCocoaButton.lclSetFrame(const r: TRect);
var
  lBtnHeight, lDiff: Integer;
  lRoundBtnSize: NSSize;
begin
  // NSTexturedRoundedBezelStyle should be the preferred style, but it has a fixed height!
  // fittingSize is 10.7+
 {  if respondsToSelector(objcselector('fittingSize')) then
  begin
    lBtnHeight := r.Bottom - r.Top;
    lRoundBtnSize := fittingSize();
    lDiff := Abs(Round(lRoundBtnSize.Height) - lBtnHeight);
    if lDiff < 4 then // this nr of pixels maximum size difference is arbitrary and we could choose another number
      setBezelStyle(NSTexturedRoundedBezelStyle)
    else
      setBezelStyle(NSTexturedSquareBezelStyle);
  end
  else
    setBezelStyle(NSTexturedSquareBezelStyle);
  }
  if (miniHeight<>0) or (smallHeight<>0) then
    SetNSControlSize(Self,r.Bottom-r.Top,miniHeight, smallHeight, adjustFontToControlSize);
  inherited lclSetFrame(r);
end;

procedure TCocoaButton.setState(astate: NSInteger);
var
  ch : Boolean;
begin
  ch := astate<>state;
  inherited setState(astate);
  if Assigned(callback) and ch then callback.SendOnChange;
end;

procedure TCocoaButton.actionButtonClick(sender: NSObject);
begin
  // this is the action handler of button
  if Assigned(callback) then
    callback.ButtonClick;
end;

procedure TCocoaButton.boundsDidChange(sender: NSNotification);
begin
  if Assigned(callback) then
    callback.boundsDidChange(self);
end;

procedure TCocoaButton.frameDidChange(sender: NSNotification);
begin
  if Assigned(callback) then
    callback.frameDidChange(self);
end;

procedure TCocoaButton.dealloc;
begin
  if Assigned(Glyph) then
    FreeAndNil(Glyph);

  inherited dealloc;
end;

function TCocoaButton.initWithFrame(frameRect: NSRect): id;
begin
  Result := inherited initWithFrame(frameRect);
  if Assigned(Result) then
  begin
    setTarget(Self);
    setAction(objcselector('actionButtonClick:'));
  //  todo: find a way to release notifications below
  //  NSNotificationCenter.defaultCenter.addObserver_selector_name_object(Self, objcselector('boundsDidChange:'), NSViewBoundsDidChangeNotification, Result);
  //  NSNotificationCenter.defaultCenter.addObserver_selector_name_object(Self, objcselector('frameDidChange:'), NSViewFrameDidChangeNotification, Result);
  //  Result.setPostsBoundsChangedNotifications(True);
  //  Result.setPostsFrameChangedNotifications(True);
  end;
end;

function TCocoaButton.acceptsFirstResponder: Boolean;
begin
  Result := True;
end;

function TCocoaButton.becomeFirstResponder: Boolean;
begin
  Result := inherited becomeFirstResponder;
  if Assigned(callback) then
    callback.BecomeFirstResponder;
end;

function TCocoaButton.resignFirstResponder: Boolean;
begin
  Result := inherited resignFirstResponder;
  if Assigned(callback) then
    callback.ResignFirstResponder;
end;

procedure TCocoaButton.drawRect(dirtyRect: NSRect);
var ctx: NSGraphicsContext;
begin
  inherited drawRect(dirtyRect);
  if CheckMainThread and Assigned(callback) then
    callback.Draw(NSGraphicsContext.currentContext, bounds, dirtyRect);
end;

function TCocoaButton.lclGetCallback: ICommonCallback;
begin
  Result := callback;
end;

procedure TCocoaButton.lclClearCallback;
begin
  callback := nil;
end;

procedure TCocoaButton.keyDown(event: NSEvent);
begin
  if not Assigned(callback) or not callback.KeyEvent(event) then
    inherited keyDown(event);
end;

procedure TCocoaButton.keyUp(event: NSEvent);
begin
  if not Assigned(callback) or not callback.KeyEvent(event) then
    inherited keyUp(event);
end;

procedure TCocoaButton.mouseUp(event: NSEvent);
begin
  if not callback.MouseUpDownEvent(event) then
    inherited mouseUp(event);
end;

procedure TCocoaButton.rightMouseDown(event: NSEvent);
begin
  if not callback.MouseUpDownEvent(event) then
    inherited rightMouseDown(event);
end;

procedure TCocoaButton.rightMouseUp(event: NSEvent);
begin
  if not callback.MouseUpDownEvent(event) then
    inherited rightMouseUp(event);
end;

procedure TCocoaButton.otherMouseDown(event: NSEvent);
begin
  if not callback.MouseUpDownEvent(event) then
    inherited otherMouseDown(event);
end;

procedure TCocoaButton.otherMouseUp(event: NSEvent);
begin
  if not callback.MouseUpDownEvent(event) then
    inherited otherMouseUp(event);
end;

procedure TCocoaButton.resetCursorRects;
begin
  if not callback.resetCursorRects then
    inherited resetCursorRects;
end;

procedure TCocoaButton.mouseDown(event: NSEvent);
begin
  if not Assigned(callback) or not callback.MouseUpDownEvent(event) then
  // We need to call the inherited regardless of the result of the call to
  // MouseUpDownEvent otherwise mouse clicks don't work, see bug 30131
    inherited mouseDown(event);
end;

procedure TCocoaButton.mouseDragged(event: NSEvent);
begin
  if not callback.MouseMove(event) then
    inherited mouseDragged(event);
end;

procedure TCocoaButton.mouseEntered(event: NSEvent);
begin
  inherited mouseEntered(event);
end;

procedure TCocoaButton.mouseExited(event: NSEvent);
begin
  inherited mouseExited(event);
end;

procedure TCocoaButton.mouseMoved(event: NSEvent);
begin
  if not callback.MouseMove(event) then
    inherited mouseMoved(event);
end;

end.
