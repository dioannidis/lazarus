{
 /***************************************************************************
                                  imglist.pp
                                  ----------
                Component Library TCustomImageList, TChangeLink Controls
                   Initial Revision  : Fri Aug 16 21:00:00 CET 1999


 ***************************************************************************/

 *****************************************************************************
  This file is part of the Lazarus Component Library (LCL)

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}

{
@author(TCustomImageList - Marc Weustink <weus@quicknet.nl>)
@author(TChangeLink - Marc Weustink <weus@quicknet.nl>)
@created(16-Aug-1999)
@lastmod(26-feb-2003)

Detailed description of the Unit.

History
  26-feb-2003 Olivier Guilbaud <golivier@free.fr>
     - Add TCustomImageList.Assign()
     - Add TCustomImageList.WriteData()
     - Add TCustomImageList.ReadData()
     - Add override TCustomImageList.DefineProperties()
       Warning : the delphi or kylix format of datas is not compatible.
     - Modify Delete and Clear for preserve memory
}
unit ImgList;

{$mode objfpc}{$H+}

interface

{$ifdef Trace}
  {$ASSERTIONS ON}
{$endif}

uses
  // RTL + FCL
  Types, math, SysUtils, Classes, FPReadBMP, FPimage, FPImgCanv, FPCanvas,
  Contnrs,
  // LazUtils
  FPCAdds,
  // LCL
  LCLStrConsts, LCLIntf, LResources, LCLType, LCLProc, Graphics, GraphType,
  LCLClasses, IntfGraphics,
  WSReferences;

type
  TImageIndex = type integer;

  { TChangeLink }
  {
    @abstract(Use a TChangelink to get notified of imagelist changes)
    Introduced by Marc Weustink <weus@quicknet.nl>
    Currently maintained by Marc Weustink <weus@quicknet.nl>
  }

  TCustomImageList = class; //forward declaration

  TChangeLink = class(TObject)
  private
    FSender: TCustomImageList;
    FOnChange: TNotifyEvent;
  public
    destructor Destroy; override;
    procedure Change; virtual;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Sender: TCustomImageList read FSender write FSender;
  end;

  { TCustomImageList }
  {
    @abstract(Contains a list of images)
    Introduced by Marc Weustink <marc@dommelstein.net>

    Delphis TCustomImageList is based on the Win32 imagelists which has
    internally only one bitmap to hold all images. This reduces handle
    allocation.
    The original TCustomImageList implementation was LCL only based, so for
    other platforms the single bitmap implementation had some speed drawbacks.
    Therefore it was implemented as list of bitmaps, however it doesnt reduce
    handle allocation.
    In its current form, the imagelist is again based on a 32bit RGBA raw
    imagedata and the widgetset is notified when images are added or removed,
    so the widgetset can create its own optimal storage. The LCL keeps only the
    data, so all transparency info will be stored cross platform. (not all
    platforms have a 8bit alpha channel).

    NOTE: due to its implementation, the TCustomImageList is not a TBitmap
    collection. If a fast storage of bitmaps is needed, create your own list!
  }
  
  // Some temp rework defines, for old functionality both need so be set

  TDrawingStyle = (dsFocus, dsSelected, dsNormal, dsTransparent);
  TImageType = (itImage, itMask);
  TOverlay = 0..14; // windows limitation

  TCustomImageListResolution = class(TLCLReferenceComponent)
  public
    FData: array of TRGBAQuad;
  private
    FWidth: Integer;
    FHeight: Integer;
    FReference: TWSCustomImageListReference;
    FAllocCount: Integer;
    FImageList: TCustomImageList;
    FCount: Integer;

    procedure AllocData(ACount: Integer);
    function  GetReference: TWSCustomImageListReference;

    function Add(Image, Mask: TCustomBitmap): Integer;
    procedure InternalInsert(AIndex: Integer; AData: PRGBAQuad); overload;
    procedure InternalMove(ACurIndex, ANewIndex: Cardinal; AIgnoreCurrent: Boolean);
    procedure InternalReplace(AIndex: Integer; AImage, AMask: HBitmap);
    function  InternalSetData(AIndex: Integer; AData: PRGBAQuad): PRGBAQuad;
    procedure CheckIndex(AIndex: Integer; AForInsert: Boolean = False);

    procedure Clear;
    procedure Delete(AIndex: Integer);

    procedure GetFullRawImage(out Image: TRawImage);

    procedure AddImages(AValue: TCustomImageListResolution);

    procedure WriteData(AStream: TStream);
    procedure ReadData(AStream: TStream);
  protected
    property ImageList: TCustomImageList read FImageList;

    function  GetReferenceHandle: THandle; override;
    function  WSCreateReference(AParams: TCreateParams): PWSReference; override;
    class procedure WSRegisterClass; override;
  public
    destructor Destroy; override;
  public
    procedure FillDescription(out ADesc: TRawImageDescription);
    procedure GetBitmap(Index: Integer; Image: TCustomBitmap); overload;
    procedure GetBitmap(Index: Integer; Image: TCustomBitmap; AEffect: TGraphicsDrawEffect); overload;
    procedure GetIcon(Index: Integer; Image: TIcon; AEffect: TGraphicsDrawEffect); overload;
    procedure GetIcon(Index: Integer; Image: TIcon); overload;
    procedure GetFullBitmap(Image: TCustomBitmap; AEffect: TGraphicsDrawEffect = gdeNormal);
    procedure GetRawImage(Index: Integer; out Image: TRawImage);

    procedure Draw(ACanvas: TCanvas; AX, AY, AIndex: Integer; AEnabled: Boolean = True); overload;
    procedure Draw(ACanvas: TCanvas; AX, AY, AIndex: Integer; ADrawEffect: TGraphicsDrawEffect); overload;
    procedure Draw(ACanvas: TCanvas; AX, AY, AIndex: Integer; ADrawingStyle: TDrawingStyle; AImageType: TImageType;
      AEnabled: Boolean = True); overload;
    procedure Draw(ACanvas: TCanvas; AX, AY, AIndex: Integer; ADrawingStyle: TDrawingStyle; AImageType: TImageType;
      ADrawEffect: TGraphicsDrawEffect); overload;
    procedure StretchDraw(Canvas: TCanvas; Index: Integer; ARect: TRect; Enabled: Boolean = True);

    procedure DrawOverlay(ACanvas: TCanvas; AX, AY, AIndex: Integer; AOverlay: TOverlay; AEnabled: Boolean = True); overload;
    procedure DrawOverlay(ACanvas: TCanvas; AX, AY, AIndex: Integer; AOverlay: TOverlay; ADrawEffect: TGraphicsDrawEffect); overload;
    procedure DrawOverlay(ACanvas: TCanvas; AX, AY, AIndex: Integer; AOverlay: TOverlay; ADrawingStyle:
      TDrawingStyle; AImageType: TImageType; ADrawEffect: TGraphicsDrawEffect); overload;

    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Count: Integer read FCount;

    property Reference: TWSCustomImageListReference read GetReference;
  end;
  TCustomImageListResolutionClass = class of TCustomImageListResolution;
  TCustomImageListResolutions = class(TObject)
  private
    FList: TObjectList;
    FImageList: TCustomImageList;
    FResolutionClass: TCustomImageListResolutionClass;

    function Find(const AImageWidth: Integer; out Index: Integer): Boolean;
    function GetImageLists(const AImageWidth: Integer): TCustomImageListResolution;
    function GetImageLists(const AImageWidth: Integer; const AScaleFromExisting: Boolean): TCustomImageListResolution;
    function GetItems(const AIndex: Integer): TCustomImageListResolution;
    function GetCount: Integer;
    function FindBestToCopyFrom(const ATargetWidth, AIgnoreIndex: Integer): Integer;
  public
    constructor Create(const AImageList: TCustomImageList; const AResolutionClass: TCustomImageListResolutionClass);
    destructor Destroy; override;
  public
    function FindBestToScaleFrom(const ATargetWidth: Integer): Integer;

    property ImageLists[const AImageWidth: Integer]: TCustomImageListResolution read GetImageLists;
    property Items[const AIndex: Integer]: TCustomImageListResolution read GetItems; default;
    property Count: Integer read GetCount;
  end;

  TCustomImageListResolutionEnumerator = class
  private
    FCurrent: Integer;
    FImgList: TCustomImageList;
    FDesc: Boolean;
    function GetCurrent: TCustomImageListResolution;
  public
    function GetEnumerator: TCustomImageListResolutionEnumerator;
    constructor Create(AImgList: TCustomImageList; ADesc: Boolean);
    function MoveNext: Boolean;
    property Current: TCustomImageListResolution read GetCurrent;
  end;

  TCustomImageListGetWidthForImagePPI = procedure(Sender: TCustomImageList;
    AImageWidth, APPI: Integer; var AResultWidth: Integer) of object;

  TCustomImageList = class(TLCLComponent)
  private
    FDrawingStyle: TDrawingStyle;
    FData: TCustomImageListResolutions;
    FImageType: TImageType;
    FHeight: Integer;
    FMasked: boolean;
    FShareImages: Boolean;
    FWidth: Integer;
    FAllocBy: Integer;
    FBlendColor: TColor;
    FOnChange: TNotifyEvent;
    FChangeLinkList: TList;
    FBkColor: TColor;
    FChanged: boolean;
    FUpdateCount: integer;
    FOverlays: array[TOverlay] of Integer;
    fHasOverlays: boolean;
    FOnGetWidthForImagePPI: TCustomImageListGetWidthForImagePPI;

    procedure NotifyChangeLink;
    procedure SetBkColor(const Value: TColor);
    procedure SetDrawingStyle(const AValue: TDrawingStyle);
    procedure SetHeight(const Value: Integer);
    procedure SetMasked(const AValue: boolean);
    procedure SetShareImages(const AValue: Boolean);
    procedure SetWidth(const Value: Integer);
    function GetReference(AImageWidth: Integer): TWSCustomImageListReference;
    function GetReferenceForImagePPI(AImageWidth, APPI: Integer): TWSCustomImageListReference;
    function GetResolutionForImagePPI(AImageWidth, APPI: Integer): TCustomImageListResolution;
    function GetWidthForImagePPI(AImageWidth, APPI: Integer): Integer;
    function GetHeightForImagePPI(AImageWidth, APPI: Integer): Integer;
    function GetCount: Integer;
    function GetSizeForImagePPI(AImageWidth, APPI: Integer): TSize;
  protected
    function GetResolution(AImageWidth: Integer): TCustomImageListResolution;
    function GetResolutionClass: TCustomImageListResolutionClass; virtual;
    procedure CheckIndex(AIndex: Integer; AForInsert: Boolean = False);
    procedure Initialize; virtual;
    procedure DefineProperties(Filer: TFiler); override;
    procedure SetWidthHeight(NewWidth, NewHeight: integer);
    procedure ClearOverlays;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateSize(AWidth, AHeight: Integer);
    destructor Destroy; override;

    class procedure ScaleImage(const ABitmap, AMask: TCustomBitmap;
      TargetWidth, TargetHeight: Integer; var AData: TRGBAQuadArray);
    class procedure ScaleImage(const ABitmap, AMask: HBITMAP;
      BitmapWidth, BitmapHeight, TargetWidth, TargetHeight: Integer; var AData: TRGBAQuadArray);

    procedure AssignTo(Dest: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
    procedure WriteData(AStream: TStream); virtual;
    procedure ReadData(AStream: TStream); virtual;
    procedure WriteAdvData(AStream: TStream); virtual;
    procedure ReadAdvData(AStream: TStream); virtual;
    function Equals(Obj: TObject): boolean;
      {$IF FPC_FULLVERSION>=20402}override;{$ENDIF}
    procedure BeginUpdate;
    procedure EndUpdate;

    function Add(Image, Mask: TCustomBitmap): Integer;
    function AddIcon(Image: TCustomIcon): Integer;
    procedure AddImages(AValue: TCustomImageList);
    function AddMasked(Image: TBitmap; MaskColor: TColor): Integer;
    function AddLazarusResource(const ResourceName: string; MaskColor: TColor = clNone): integer;
    function AddResourceName(Instance: THandle; const ResourceName: string; MaskColor: TColor = clNone): integer;
    procedure Change;
    procedure Clear;
    procedure Delete(AIndex: Integer);
    procedure Draw(ACanvas: TCanvas; AX, AY, AIndex: Integer; AEnabled: Boolean = True); overload;
    procedure Draw(ACanvas: TCanvas; AX, AY, AIndex: Integer; ADrawEffect: TGraphicsDrawEffect); overload;
    procedure Draw(ACanvas: TCanvas; AX, AY, AIndex: Integer; ADrawingStyle: TDrawingStyle; AImageType: TImageType;
      AEnabled: Boolean = True); overload;
    procedure Draw(ACanvas: TCanvas; AX, AY, AIndex: Integer; ADrawingStyle: TDrawingStyle; AImageType: TImageType;
      ADrawEffect: TGraphicsDrawEffect); overload;
    procedure DrawOverlay(ACanvas: TCanvas; AX, AY, AIndex: Integer; AOverlay: TOverlay; AEnabled: Boolean = True); overload;
    procedure DrawOverlay(ACanvas: TCanvas; AX, AY, AIndex: Integer; AOverlay: TOverlay; ADrawEffect: TGraphicsDrawEffect); overload;
    procedure DrawOverlay(ACanvas: TCanvas; AX, AY, AIndex: Integer; AOverlay: TOverlay; ADrawingStyle:
      TDrawingStyle; AImageType: TImageType; ADrawEffect: TGraphicsDrawEffect); overload;

    procedure GetBitmap(Index: Integer; Image: TCustomBitmap); overload;
    procedure GetBitmap(Index: Integer; Image: TCustomBitmap; AEffect: TGraphicsDrawEffect); overload;
    procedure GetFullBitmap(Image: TCustomBitmap; AEffect: TGraphicsDrawEffect = gdeNormal);
    procedure GetFullRawImage(out Image: TRawImage);

    procedure GetIcon(Index: Integer; Image: TIcon; AEffect: TGraphicsDrawEffect); overload;
    procedure GetIcon(Index: Integer; Image: TIcon); overload;
    procedure GetRawImage(Index: Integer; out Image: TRawImage);
    function GetHotSpot: TPoint; virtual;

    procedure Insert(AIndex: Integer; AImage, AMask: TCustomBitmap);
    procedure InsertIcon(AIndex: Integer; AIcon: TCustomIcon);
    procedure InsertMasked(Index: Integer; AImage: TCustomBitmap; MaskColor: TColor);
    procedure Move(ACurIndex, ANewIndex: Integer);
    procedure Overlay(AIndex: Integer; Overlay: TOverlay);
    property HasOverlays: boolean read fHasOverlays;
    procedure Replace(AIndex: Integer; AImage, AMask: TCustomBitmap);
    procedure ReplaceMasked(Index: Integer; NewImage: TCustomBitmap; MaskColor: TColor);
    procedure RegisterChanges(Value: TChangeLink);
    procedure StretchDraw(Canvas: TCanvas; Index: Integer; ARect: TRect; Enabled: Boolean = True);
    procedure UnRegisterChanges(Value: TChangeLink);
    function Resolutions: TCustomImageListResolutionEnumerator;
    function ResolutionsDesc: TCustomImageListResolutionEnumerator;
  public
    property AllocBy: Integer read FAllocBy write FAllocBy default 4;
    property BlendColor: TColor read FBlendColor write FBlendColor default clNone;
    property BkColor: TColor read FBkColor write SetBkColor default clNone;
    property Count: Integer read GetCount;
    property DrawingStyle: TDrawingStyle read FDrawingStyle write SetDrawingStyle default dsNormal;
    property Height: Integer read FHeight write SetHeight default 16;
    property HeightForImagePPI[AImageWidth, APPI: Integer]: Integer read GetHeightForImagePPI;
    property Width: Integer read FWidth write SetWidth default 16;
    property WidthForImagePPI[AImageWidth, APPI: Integer]: Integer read GetWidthForImagePPI;
    property SizeForImagePPI[AImageWidth, APPI: Integer]: TSize read GetSizeForImagePPI;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Masked: boolean read FMasked write SetMasked default False;
    property Reference[AImageWidth: Integer]: TWSCustomImageListReference read GetReference;
    property ReferenceForImagePPI[AImageWidth, APPI: Integer]: TWSCustomImageListReference read GetReferenceForImagePPI;
    property Resolution[AImageWidth: Integer]: TCustomImageListResolution read GetResolution;
    property ResolutionForImagePPI[AImageWidth, APPI: Integer]: TCustomImageListResolution read GetResolutionForImagePPI;
    property ShareImages: Boolean read FShareImages write SetShareImages default False;
    property ImageType: TImageType read FImageType write FImageType default itImage;
    property OnGetWidthForImagePPI: TCustomImageListGetWidthForImagePPI read FOnGetWidthForImagePPI write FOnGetWidthForImagePPI;
  end;

implementation

uses
  WSImglist;

{$I imglist.inc}

end.

