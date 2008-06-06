{  $Id$  }
{
 /***************************************************************************
                            lclstrconsts.pas
                            ----------------
     This unit contains all resource strings of the LCL (not interfaces)


 ***************************************************************************/

 *****************************************************************************
 *                                                                           *
 *  This file is part of the Lazarus Component Library (LCL)                 *
 *                                                                           *
 *  See the file COPYING.modifiedLGPL, included in this distribution,        *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************
}
unit LCLStrConsts;

{$mode objfpc}{$H+}

interface

ResourceString
  // common Delphi strings
  SNoMDIForm = 'No MDI form present.';

  // message/input dialog buttons
  rsMbYes          = '&Yes';
  rsMbNo           = '&No';
  rsMbOK           = '&OK';
  rsMbCancel       = 'Cancel';
  rsMbAbort        = 'Abort';
  rsMbRetry        = '&Retry';
  rsMbIgnore       = '&Ignore';
  rsMbAll          = '&All';
  rsMbNoToAll      = 'No to all';
  rsMbYesToAll     = 'Yes to &All';
  rsMbHelp         = '&Help';
  rsMbClose        = '&Close';

  rsMtWarning      = 'Warning';
  rsMtError        = 'Error';
  rsMtInformation  = 'Information';
  rsMtConfirmation = 'Confirmation';
  rsMtCustom       = 'Custom';

  // file dialog
  rsfdOpenFile           = 'Open existing file';
  rsfdOverwriteFile      = 'Overwrite file ?';
  rsfdFileAlreadyExists  = 'The file "%s" already exists. Overwrite ?';
  rsfdPathMustExist      = 'Path must exist';
  rsfdPathNoExist        = 'The path "%s" does not exist.';
  rsfdFileMustExist      = 'File must exist';
  rsfdDirectoryMustExist = 'Directory must exist';
  rsfdFileNotExist       = 'The file "%s" does not exist.';
  rsfdDirectoryNotExist  = 'The directory "%s" does not exist.';
  rsFind = 'Find';
  rsfdFileReadOnlyTitle  = 'File is not writable';
  rsfdFileReadOnly       = 'The file "%s" is not writable.';
  rsfdFileSaveAs         = 'Save file as';
  rsAllFiles = 'All files (%s)|%s|%s';
  rsfdSelectDirectory    = 'Select Directory';
  rsDirectory            = '&Directory';

  // Select color dialog
  rsSelectcolorTitle    = 'Select color';
   
  // Select font dialog
  rsSelectFontTitle     = 'Select a font';
  rsFindMore = 'Find more';
  rsReplace = 'Replace';
  rsReplaceAll = 'Replace all';
  
  // DBGrid
  rsDeleteRecord = 'Delete record?';
  
  // gtk interface
  rsWarningUnremovedPaintMessages = ' WARNING: There are %s unremoved LM_'
    +'PAINT/LM_GtkPAINT message links left.';
  rsWarningUnreleasedDCsDump = ' WARNING: There are %d unreleased DCs, a '
    +'detailed dump follows:';
  rsWarningUnreleasedGDIObjectsDump = ' WARNING: There are %d unreleased '
    +'GDIObjects, a detailed dump follows:';
  rsWarningUnreleasedMessagesInQueue = ' WARNING: There are %d messages left '
    +'in the queue! I''ll free them';
  rsWarningUnreleasedTimerInfos = ' WARNING: There are %d TimerInfo '
    +'structures left, I''ll free them';
  rsFileInformation = 'File information';
  rsgtkFilter = 'Filter:';
  rsgtkHistory = 'History:';
  rsDefaultFileInfoValue = 'permissions user group size date time';
  rsBlank = 'Blank';
  rsUnableToLoadDefaultFont = 'Unable to load default font';
  rsFileInfoFileNotFound = '(file not found: "%s")';
  rsgtkOptionNoTransient = '--lcl-no-transient    Do not set transient order for'
    +' modal forms';
  rsgtkOptionModule = '--gtk-module module   Load the specified module at '
    +'startup.';
  rsgOptionFatalWarnings = '--g-fatal-warnings    Warnings and errors '
    +'generated by Gtk+/GDK will halt the application.';
  rsgtkOptionDebug = '--gtk-debug flags     Turn on specific Gtk+ trace/'
    +'debug messages.';
  rsgtkOptionNoDebug = '--gtk-no-debug flags  Turn off specific Gtk+ trace/'
    +'debug messages.';
  rsgdkOptionDebug = '--gdk-debug flags     Turn on specific GDK trace/debug '
    +'messages.';
  rsgdkOptionNoDebug = '--gdk-no-debug flags  Turn off specific GDK trace/'
    +'debug messages.';
  rsgtkOptionDisplay = '--display h:s:d       Connect to the specified X '
    +'server, where "h" is the hostname, "s" is the server number (usually 0), '
    +'and "d" is the display number (typically omitted). If --display is not '
    +'specified, the DISPLAY environment variable is used.';
  rsgtkOptionSync = '--sync                Call XSynchronize (display, True) '
    +'after the Xserver connection has been established. This makes debugging '
    +'X protocol errors easier, because X request buffering will be disabled '
    +'and X errors will be received immediatey after the protocol request that '
    +'generated the error has been processed by the X server.';
  rsgtkOptionNoXshm = '--no-xshm             Disable use of the X Shared '
    +'Memory Extension.';
  rsgtkOptionName = '--name programe       Set program name to "progname". '
    +'If not specified, program name will be set to ParamStr(0).';
  rsgtkOptionClass = '--class classname     Following Xt conventions, the '
    +'class of a program is the program name with the initial character '
    +'capitalized. For example, the classname for gimp is "Gimp". If --class '
    +'is specified, the class of the program will be set to "classname".';
     
  // win32 interface
  rsWin32Warning = 'Warning:';
  rsWin32Error = 'Error:';
  
  // StringHashList, LResource, Menus, ExtCtrls, ImgList, Spin
  // StdCtrls, Calendar, CustomTimer, Forms, Grids, LCLProc, Controls, ComCtrls,
  // ExtDlgs, EditBtn, Masks
  sInvalidActionRegistration = 'Invalid action registration';
  sInvalidActionUnregistration = 'Invalid action unregistration';
  sInvalidActionEnumeration = 'Invalid action enumeration';
  sInvalidActionCreation = 'Invalid action creation';
  sMenuNotFound   = 'Sub-menu is not in menu';
  sMenuIndexError = 'Menu index out of range';
  sMenuItemIsNil  = 'MenuItem is nil';
  sNoTimers = 'No timers available';
  sInvalidIndex = 'Invalid ImageList Index';
  sInvalidImageSize = 'Invalid image size';
  sDuplicateMenus = 'Duplicate menus';
  sCannotFocus = 'Cannot focus a disabled or invisible window';
  sInvalidCharSet = 'The char set in mask "%s" is not valid!';

  rsListMustBeEmpty = 'List must be empty';
  rsInvalidPropertyValue = 'Invalid property value';
  rsPropertyDoesNotExist = 'Property %s does not exist';
  rsInvalidStreamFormat = 'Invalid stream format';
  rsErrorReadingProperty = 'Error reading %s%s%s: %s';
  rsInvalidFormObjectStream = 'invalid Form object stream';
  rsScrollBarOutOfRange = 'ScrollBar property out of range';
  rsInvalidDate = 'Invalid Date : %s';
  rsInvalidDateRangeHint = 'Invalid Date: %s. Must be between %s and %s';
  rsErrorOccurredInAtAddressFrame = 'Error occurred in %s at %sAddress %s%s'
    +' Frame %s';
  rsException = 'Exception';
  rsFormStreamingError = 'Form streaming "%s" error: %s';
  rsFixedColsTooBig = 'FixedCols can''t be >= ColCount';
  rsFixedRowsTooBig = 'FixedRows can''t be >= RowCount';
  rsGridFileDoesNotExists = 'Grid file doesn''t exists';
  rsNotAValidGridFile = 'Not a valid grid file';
  rsIndexOutOfRange = 'Index Out of range Cell[Col=%d Row=%d]';
  rsGridIndexOutOfRange = 'Grid index out of range.';
  rsERRORInLCL = 'ERROR in LCL: ';
  rsCreatingGdbCatchableError = 'Creating gdb catchable error:';
  rsAControlCanNotHaveItselfAsParent = 'A control can''t have itself as parent';
  lisLCLResourceSNotFound = 'Resource %s not found';
  rsErrorCreatingDeviceContext = 'Error creating device context for %s.%s';
  rsIndexOutOfBounds = '%s Index %d out of bounds 0 .. %d';
  rsUnknownPictureExtension = 'Unknown picture extension';
  rsBitmaps = 'Bitmaps';
  rsPixmap = 'Pixmap';
  rsPortableNetworkGraphic = 'Portable Network Graphic';
  rsPortableBitmap = 'Portable BitMap';
  rsPortableGrayMap = 'Portable GrayMap';
  rsPortablePixmap = 'Portable PixMap';
  rsIcon = 'Icon';
  rsJpeg = 'Joint Picture Expert Group';
  rsUnsupportedClipboardFormat = 'Unsupported clipboard format: %s';
  rsGroupIndexCannotBeLessThanPrevious = 'GroupIndex cannot be less than a '
    +'previous menu item''s GroupIndex';
  rsIsAlreadyAssociatedWith = '%s is already associated with %s';
  rsCanvasDoesNotAllowDrawing = 'Canvas does not allow drawing';
  rsUnsupportedBitmapFormat = 'Unsupported bitmap format.';
  rsErrorWhileSavingBitmap = 'Error while saving bitmap.';
  rsNoWidgetSet = 'No widgetset object. '
    +'Please check if the unit "interfaces" was added to the programs uses clause.';
  rsPressOkToIgnoreAndRiskDataCorruptionPressCancelToK = '%s%sPress Ok to '
    +'ignore and risk data corruption.%sPress Cancel to kill the program.';
  rsCanNotFocus = 'Can not focus';
  rsListIndexExceedsBounds = 'List index exceeds bounds (%d)';
  rsResourceNotFound = 'Resource %s not found';
  rsCalculator = 'Calculator';
  rsError      = 'Error';
  rsPickDate   = 'Select a date';
  rsSize = '  size ';
  rsModified = '  modified ';

  // I'm not sure if in all languages the Dialog texts for a button
  // have the same meaning as a key
  // So every VK gets its own constant
  ifsVK_UNKNOWN    = 'Unknown';
  ifsVK_LBUTTON    = 'Mouse Button Left';
  ifsVK_RBUTTON    = 'Mouse Button Right';
  ifsVK_CANCEL     = 'Cancel'; //= dlgCancel
  ifsVK_MBUTTON    = 'Mouse Button Middle';
  ifsVK_BACK       = 'Backspace';
  ifsVK_TAB        = 'Tab';
  ifsVK_CLEAR      = 'Clear';
  ifsVK_RETURN     = 'Return';
  ifsVK_SHIFT      = 'Shift';
  ifsVK_CONTROL    = 'Control';
  ifsVK_MENU       = 'Menu';
  ifsVK_PAUSE      = 'Pause key';
  ifsVK_CAPITAL    = 'Capital';
  ifsVK_KANA       = 'Kana';
  ifsVK_JUNJA      = 'Junja';
  ifsVK_FINAL      = 'Final';
  ifsVK_HANJA      = 'Hanja';
  ifsVK_ESCAPE     = 'Escape';
  ifsVK_CONVERT    = 'Convert';
  ifsVK_NONCONVERT = 'Nonconvert';
  ifsVK_ACCEPT     = 'Accept';
  ifsVK_MODECHANGE = 'Mode Change';
  ifsVK_SPACE      = 'Space key';
  ifsVK_PRIOR      = 'Prior';
  ifsVK_NEXT       = 'Next';
  ifsVK_END        = 'End';
  ifsVK_HOME       = 'Home';
  ifsVK_LEFT       = 'Left';
  ifsVK_UP         = 'Up';
  ifsVK_RIGHT      = 'Right';
  ifsVK_DOWN       = 'Down'; //= dlgdownword
  ifsVK_SELECT     = 'Select'; //= lismenuselect
  ifsVK_PRINT      = 'Print';
  ifsVK_EXECUTE    = 'Execute';
  ifsVK_SNAPSHOT   = 'Snapshot';
  ifsVK_INSERT     = 'Insert';
  ifsVK_DELETE     = 'Delete'; //= dlgeddelete
  ifsVK_HELP       = 'Help';
  ifsCtrl          = 'Ctrl';
  ifsAlt           = 'Alt';
  rsWholeWordsOnly = 'Whole words only';
  rsCaseSensitive = 'Case sensitive';
  rsText = 'Text';
  rsDirection = 'Direction';
  rsForward = 'Forward';
  rsBackward = 'Backward';
  ifsVK_LWIN       = 'left windows key';
  ifsVK_RWIN       = 'right windows key';
  ifsVK_APPS       = 'application key';
  ifsVK_NUMPAD     = 'Numpad %d';
  ifsVK_NUMLOCK    = 'Numlock';
  ifsVK_SCROLL     = 'Scroll';

  // docking
  rsDocking = 'Docking';

  // help
  rsHelpHelpNodeHasNoHelpDatabase = 'Help node %s%s%s has no Help Database';
  rsHelpThereIsNoViewerForHelpType = 'There is no viewer for help type %s%s%s';
  rsHelpHelpDatabaseDidNotFoundAViewerForAHelpPageOfType = 'Help Database %s%'
    +'s%s did not found a viewer for a help page of type %s';
  rsHelpAlreadyRegistered = '%s: Already registered';
  rsHelpNotRegistered = '%s: Not registered';
  rsHelpHelpDatabaseNotFound = 'Help Database %s%s%s not found';
  rsHelpHelpKeywordNotFoundInDatabase = 'Help keyword %s%s%s not found in '
    +'Database %s%s%s.';
  rsHelpHelpKeywordNotFound = 'Help keyword %s%s%s not found.';
  rsHelpHelpContextNotFoundInDatabase = 'Help context %s not found in '
    +'Database %s%s%s.';
  rsHelpHelpContextNotFound = 'Help context %s not found.';
  rsHelpNoHelpFoundForSource = 'No help found for line %d, column %d of %s.';
  rsHelpNoHelpNodesAvailable = 'No help nodes available';
  rsHelpError = 'Help Error';
  rsHelpDatabaseNotFound = 'Help Database not found';
  rsHelpContextNotFound = 'Help Context not found';
  rsHelpViewerNotFound = 'Help Viewer not found';
  rsHelpNotFound = 'Help not found';
  rsHelpViewerError = 'Help Viewer Error';
  rsHelpSelectorError = 'Help Selector Error';
  rsUnknownErrorPleaseReportThisBug = 'Unknown Error, please report this bug';

  hhsHelpTheHelpDatabaseWasUnableToFindFile = 'The help database %s%s%s was '
    +'unable to find file %s%s%s.';
  hhsHelpTheMacroSInBrowserParamsWillBeReplacedByTheURL = 'The macro %s in '
    +'BrowserParams will be replaced by the URL.';
  hhsHelpNoHTMLBrowserFoundPleaseDefineOneInHelpConfigureHe = 'No HTML '
    +'Browser found.%sPlease define one in Help -> Configure Help -> Viewers';
  hhsHelpNoHTMLBrowserFound = 'Unable to find a HTML browser.';
  hhsHelpBrowserNotFound = 'Browser %s%s%s not found.';
  hhsHelpBrowserNotExecutable = 'Browser %s%s%s not executable.';
  hhsHelpErrorWhileExecuting = 'Error while executing %s%s%s:%s%s';

  // parser
  SParExpected                  = 'Wrong token type: %s expected';
  SParInvalidInteger            = 'Invalid integer number: %s';
  SParWrongTokenType            = 'Wrong token type: %s expected but %s found';
  SParInvalidFloat              = 'Invalid floating point number: %s';
  SParWrongTokenSymbol          = 'Wrong token symbol: %s expected but %s found';
  SParUnterminatedString        = 'Unterminated string';
  SParLocInfo                   = ' (at %d,%d, stream offset %.8x)';
  SParUnterminatedBinValue      = 'Unterminated byte value';

implementation

end.

