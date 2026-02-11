unit Unit1;

{$mode delphi}
{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ATShapeLineBGRA, BCButton;

type
  TSudokuGrid = array[0..8, 0..8] of integer;

  { TForm1 }

  TForm1 = class(TForm)
    SolveButton: TBCButton;
    ClearButton: TBCButton;
    Input11: TEdit;
    Input12: TEdit;
    Input13: TEdit;
    Input14: TEdit;
    Input15: TEdit;
    Input16: TEdit;
    Input17: TEdit;
    Input18: TEdit;
    Input19: TEdit;
    Input21: TEdit;
    Input22: TEdit;
    Input23: TEdit;
    Input24: TEdit;
    Input25: TEdit;
    Input26: TEdit;
    Input27: TEdit;
    Input28: TEdit;
    Input29: TEdit;
    Input31: TEdit;
    Input32: TEdit;
    Input33: TEdit;
    Input34: TEdit;
    Input35: TEdit;
    Input36: TEdit;
    Input37: TEdit;
    Input38: TEdit;
    Input39: TEdit;
    Input41: TEdit;
    Input42: TEdit;
    Input43: TEdit;
    Input44: TEdit;
    Input45: TEdit;
    Input46: TEdit;
    Input47: TEdit;
    Input48: TEdit;
    Input49: TEdit;
    Input51: TEdit;
    Input52: TEdit;
    Input53: TEdit;
    Input54: TEdit;
    Input55: TEdit;
    Input56: TEdit;
    Input57: TEdit;
    Input58: TEdit;
    Input59: TEdit;
    Input61: TEdit;
    Input62: TEdit;
    Input63: TEdit;
    Input64: TEdit;
    Input65: TEdit;
    Input66: TEdit;
    Input67: TEdit;
    Input68: TEdit;
    Input69: TEdit;
    Input71: TEdit;
    Input72: TEdit;
    Input73: TEdit;
    Input74: TEdit;
    Input75: TEdit;
    Input76: TEdit;
    Input77: TEdit;
    Input78: TEdit;
    Input79: TEdit;
    Input81: TEdit;
    Input82: TEdit;
    Input83: TEdit;
    Input84: TEdit;
    Input85: TEdit;
    Input86: TEdit;
    Input87: TEdit;
    Input88: TEdit;
    Input89: TEdit;
    Input91: TEdit;
    Input92: TEdit;
    Input93: TEdit;
    Input94: TEdit;
    Input95: TEdit;
    Input96: TEdit;
    Input97: TEdit;
    Input98: TEdit;
    Input99: TEdit;
    DebugLabel: TLabel;
    ShapeLineBGRA1: TShapeLineBGRA;
    ShapeLineBGRA2: TShapeLineBGRA;
    ShapeLineBGRA3: TShapeLineBGRA;
    ShapeLineBGRA4: TShapeLineBGRA;

    procedure FormShow(Sender: TObject);

    function getEditName(const row, col: integer): string;
    function getEdit(const row, col: integer): TEdit;

    procedure ClearButtonClick(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure SolveButtonClick(Sender: TObject);

    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditChange(Sender: TObject);
    procedure EditEnter(Sender: TObject);
  private
    { Colours are in BGR }
    defaultBackground: longword;
    highlight1: longword;
    highlight2: longword;  { subtle highlight }
    accent: longword;

    defaultForeground: longword;
    readonlyForeground: longword;

    stateGrid: TSudokuGrid;
    solvedGrid: array[0..8, 0..8] of boolean;  { solved by the algorithm }

    procedure debugNumbers;
  public

  end;

var
  Form1: TForm1;


implementation

uses LCLType;

{$R *.lfm}

{ TForm1 }

function usedInRow(const grid: TSudokuGrid; const row, num: integer): boolean;
var
  col: integer;
begin
  for col := 0 to 8 do
    if grid[row][col] = num then begin
      usedInRow := true;
      exit
    end;

  usedInRow := false
end;

function usedInCol(const grid: TSudokuGrid; const col, num: integer): boolean;
var
  row: integer;
begin
  for row := 0 to 8 do
    if grid[row][col] = num then begin
      usedInCol := true;
      exit
    end;

  usedInCol := false
end;

function usedInBox(const grid: TSudokuGrid; const boxStartRow, boxStartCol, num: integer): boolean;
var
  row, col: integer;
begin
  for row := 0 to 2 do
    for col := 0 to 2 do
      if grid[row + boxStartRow][col + boxStartCol] = num then begin
        usedInBox := true;
        exit
      end;

  usedInBox := false
end;

function isSafe(const grid: TSudokuGrid; const row, col, num: integer): boolean;
begin
  isSafe := (not usedInRow(grid, row, num))
    and (not usedInCol(grid, col, num))
    and (not usedInBox(grid, row - row mod 3, col - col mod 3, num));
end;

function findUnassignedLocation(const grid: TSudokuGrid; var row, col: integer): boolean;
var
  tempRow, tempCol: integer;
begin
  for tempRow := 0 to 8 do
  for tempCol := 0 to 8 do
    if grid[tempRow][tempCol] = 0 then begin
      findUnassignedLocation := true;
      row := tempRow;
      col := tempCol;
      exit
    end;

  row := tempRow;
  col := tempCol;
  findUnassignedLocation := false
end;

function SolveSudoku(var grid: TSudokuGrid): boolean;
var
  row, col, num: integer;
begin
  if not findUnassignedLocation(grid, row, col) then begin
    SolveSudoku := true;
    exit
  end;

  for num := 1 to 9 do begin
    if isSafe(grid, row, col, num) then begin
      grid[row][col] := num;

      if solveSudoku(grid) then begin
        SolveSudoku := true;
        exit
      end;

      grid[row][col] := 0
    end;
  end;

  SolveSudoku := false
end;

{
procedure TForm1.FormCreate(Sender: TObject);
var
  a, b: integer;
  inputBox: TEdit;
begin
  for b:=0 to 8 do
  for a:=0 to 8 do begin
    inputbox := tedit.create(self);

    inputbox.name := getEditName(b, a);

    inputbox.parent := self;
    inputbox.left := 20 + a * 40;
    inputbox.top := 20 + b * 40;
    inputbox.width := 30;
    inputbox.height := 30;

    inputbox.NumbersOnly := true;
    inputbox.maxlength := 1;
    inputbox.text := '';

    inputbox.Font := edit1.font;
    inputbox.alignment := taCenter;

    inputbox.OnKeyDown := EditKeyDown;
    inputbox.OnChange := EditChange;
    inputbox.OnEnter := EditEnter;
  end;
end;
}

function RGBToBGR(colour: longword): longword;
begin
  result := (colour and $FF) shl 16
  or (colour and $FF00)
  or (colour shr 16) and $FF
end;

procedure TForm1.EditEnter(Sender: TObject);
var
  thisEdit: TEdit;
  row, col, a: smallint;
begin
  thisEdit := TEdit(sender);
  thisEdit.Color := highlight1;
  thisEdit.SelectAll;

  DebugLabel.Caption := thisEdit.name;
  row := strtoint(thisEdit.name[6]);
  col := strtoint(thisEdit.name[7]);

  for a:=1 to 9 do
    if col <> a then
      getEdit(row, a).color := highlight2;

  for a:=1 to 9 do
    if row <> a then
      getEdit(a, col).color := highlight2;
end;

procedure TForm1.EditExit(Sender: TObject);
var
  thisEdit: TEdit;
  row, col, a: smallint;
begin
  thisEdit := TEdit(sender);
  thisEdit.Color := defaultBackground;

  row := strtoint(thisEdit.name[6]);
  col := strtoint(thisEdit.name[7]);

  for a:=1 to 9 do
    if col <> a then
      getEdit(row, a).color := defaultBackground;

  for a:=1 to 9 do
    if row <> a then
      getEdit(a, col).color := defaultBackground;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  a, b: word;
  inputbox: TEdit;
begin
  { Define theme colours here }
  defaultBackground := RGBToBGR($202020);
  accent := RGBToBGR($ECF708);
  highlight1 := RGBToBGR($8f9907);
  highlight2 := RGBToBGR($555b04);

  defaultForeground := clWhite;
  readonlyForeground := RGBToBGR($999999);

  color := defaultBackground;

  for b:=1 to 9 do
  for a:=1 to 9 do begin
    inputbox := getEdit(b, a);

    inputbox.Color := defaultBackground;
    inputbox.Font.Color := defaultForeground;

    inputbox.OnKeyDown := EditKeyDown;
    inputbox.OnChange := EditChange;
    inputbox.OnEnter := EditEnter;
    inputbox.OnExit := EditExit;
  end;
end;

function TForm1.getEditName(const row, col: integer): string;
begin
  getEditName := format('Input%d%d', [row, col])
end;

function TForm1.getEdit(const row, col: integer): TEdit;
var
  nameToFind: string;
begin
  nameToFind := getEditName(row, col);
  getEdit := TEdit(FindComponent(nameToFind))
end;


procedure TForm1.debugNumbers;
var
  tempStr: string;
  row, col: smallint;
begin
  { Debug numbers }
  DebugLabel.caption := '';
  for row:=0 to 8 do begin
    tempStr := '';
    for col:=0 to 8 do
      if col = 8 then
        tempStr := tempStr + inttostr(stateGrid[row][col])
      else
        tempStr := tempStr + inttostr(stateGrid[row][col]) + ', ';

    DebugLabel.caption := DebugLabel.caption + tempStr + chr(13);
  end;
end;

procedure TForm1.SolveButtonClick(Sender: TObject);
var
  row, col: integer;
  val: integer;
  inputbox: TEdit;
begin
  for row:=1 to 9 do
  for col:=1 to 9 do begin
    inputbox := getEdit(row, col);
    if TryStrToInt(inputbox.text, val) then
      stateGrid[row-1][col-1] := val
    else
      stateGrid[row-1][col-1] := 0;
  end;

  for row:=0 to 8 do
  for col:=0 to 8 do
    solvedGrid[row][col] := false;

  if solveSudoku(stateGrid) then
    for row:=1 to 9 do
    for col:=1 to 9 do begin
      solvedGrid[row-1][col-1] := true;

      inputbox := getEdit(row, col);
      inputbox.ReadOnly := true;
      inputbox.font.color := readonlyForeground;

      if length(inputbox.text) = 0 then begin
        inputbox.Font.Bold := true;
        inputbox.Font.Color := defaultForeground;
      end;

      inputbox.text := inttostr(stateGrid[row-1][col-1]);
    end
  else
    MessageDlg('No solutions found', mtInformation, [mbOK], 0);
end;

procedure TForm1.ClearButtonClick(Sender: TObject);
var
  a, b: integer;
  inputbox: TEdit;
begin
  if MessageDlg('Clear inputs?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;

  DebugLabel.caption := '';

  for b:=1 to 9 do
  for a:=1 to 9 do begin
    inputbox := getEdit(b, a);

    if assigned(inputbox) then begin
      inputbox.text := '';
      inputbox.font.bold := false;
      inputbox.color := defaultBackground;
      inputbox.font.Color := defaultForeground;
      inputbox.ReadOnly := false;
    end;
  end;
end;

procedure TForm1.EditKeyDown(
  Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  currentEdit: TEdit;
  currentName: string;
  row, col: integer;
begin
  currentEdit := TEdit(sender);
  currentName := currentEdit.name;
  row := strToInt(currentName[6]);
  col := strToInt(currentName[7]);

  case key of
    vk_up: dec(row);
    vk_down: inc(row);

    vk_left: dec(col);
    vk_right: inc(col);
  end;

  if (row in [1..9]) and (col in [1..9]) then
    getEdit(row, col).SetFocus;
end;

procedure TForm1.EditChange(Sender: TObject);
var
  thisEdit: TEdit;
  thisName: string;
  row, col: integer;
begin
  thisEdit := TEdit(sender);

  if thisEdit.text <> '' then begin
    thisName := thisEdit.name;
    row := strToInt(thisName[6]);
    col := strToInt(thisName[7]);
    inc(col);

    { Handle wrapping }
    if col > 9 then begin
      inc(row);
      col := 1
    end;
    if row > 9 then row := 1;

    getEdit(row, col).setFocus
  end;
end;


end.

