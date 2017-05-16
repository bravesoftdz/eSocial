{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 01/03/2015: Guilherme Costa
|*  - Ao gerar o per�odo a tag deve se chamar "novaValidade"
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S1070;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;


type
  TS1070Collection = class;
  TS1070CollectionItem = class;
  TEvtTabProcesso = class;
  TDadosProcJud = class;
  TDadosProc = class;
  TInfoProcesso = class;
  TIdeProcesso = class;


  TS1070Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1070CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1070CollectionItem);
  public
    function Add: TS1070CollectionItem;
    property Items[Index: Integer]: TS1070CollectionItem read GetItem write SetItem; default;
  end;

  TS1070CollectionItem = class(TCollectionItem)
   private
    FTipoEvento: TTipoEvento;
    FEvtTabProcesso: TEvtTabProcesso;
    procedure setEvtTabProcesso(const Value: TEvtTabProcesso);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor  Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtTabProcesso: TEvtTabProcesso read FEvtTabProcesso write setEvtTabProcesso;
  end;

  TIdeProcesso = class(TPersistent)
   private
    FTpProc : tpTpProc;
    FNrProc : string;
    FIniValid: string;
    FFimValid: string;
  published
    property tpProc :tpTpProc read FTpProc write FTpProc;
    property nrProc :string read FNrProc write FNrProc;
    property iniValid: string read FIniValid write FIniValid;
    property fimValid: string read FFimValid write FFimValid;
  end;

  TEvtTabProcesso = class(TESocialEvento)
   private
    FModoLancamento: TModoLancamento;
    fIdeEvento: TIdeEvento;
    fIdeEmpregador: TIdeEmpregador;
    fInfoProcesso: TInfoProcesso;

    {Geradores espec�ficos da classe}
    procedure gerarIdeProcesso();
    procedure gerarDadosProcJud();
    procedure gerarDadosProc();
    procedure gerarDadosInfoSusp();
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;

    property ModoLancamento: TModoLancamento read FModoLancamento write FModoLancamento;
    property IdeEvento: TIdeEvento read fIdeEvento write fIdeEvento;
    property IdeEmpregador: TIdeEmpregador read fIdeEmpregador write fIdeEmpregador;
    property InfoProcesso: TInfoProcesso read fInfoProcesso write fInfoProcesso;
  end;

  TInfoSuspCollectionItem = class(TCollectionItem)
  private
   FCodSusp: Integer;
   FIndSusp: tpIndSusp;
   FDTDecisao: TDate;
   FIndDeposito: tpSimNao;
  public
    constructor create; reintroduce;

    property codSusp: Integer read FCodSusp write FCodSusp;
    property indSusp: tpIndSusp read FIndSusp write FIndSusp;
    property dtDecisao: TDate read FDTDecisao write FDTDecisao;
    property indDeposito: tpSimNao read FIndDeposito write FIndDeposito;
  end;


  TInfoSuspCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TInfoSuspCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoSuspCollectionItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TInfoSuspCollectionItem;
    property Items[Index: Integer]: TInfoSuspCollectionItem read GetItem write SetItem; default;
  end;

  TDadosProcJud = class(TPersistent)
   private
    FUfVara: string;
    FCodMunic: integer;
    FIdVara: string;
  public
    property UfVara: string read FUfVara write FUfVara;
    property codMunic: integer read FCodMunic write FCodMunic;
    property idVara: string read FIdVara write FIdVara;
  end;

  TDadosProc = class(TPersistent)
   private
    FIndAutoria: tpindAutoria;
    FIndMatProc:  tpIndMatProc;
    FDadosProcJud : TDadosProcJud;
    FInfoSusp: TInfoSuspCollection;
    function getDadosProcJud: TDadosProcJud;
    function getInfoSusp(): TInfoSuspCollection;
  public
    constructor create;
    destructor Destroy; override;
    function dadosProcJudInst(): Boolean;
    function infoSuspInst(): Boolean;

    property indAutoria: tpindAutoria read FIndAutoria write FIndAutoria;
    property indMatProc: tpIndMatProc read FIndMatProc write FIndMatProc;
    property DadosProcJud: TDadosProcJud read getDadosProcJud write FDadosProcJud;
    property infoSusp: TInfoSuspCollection read getInfoSusp write FInfoSusp;
  end;

  TInfoProcesso = class
   private
    FIdeProcesso: TIdeProcesso;
    FDadosProc: TDadosProc;
    FNovaValidade: TIdePeriodo;
    function getDadosProc(): TDadosProc;
    function getNovaValidade(): TIdePeriodo;
  public
    constructor create;
    destructor Destroy; override;
    function dadosProcsInst(): Boolean;
    function novaValidadeInst(): Boolean;

    property ideProcesso: TIdeProcesso read FIdeProcesso write FIdeProcesso;
    property dadosProc: TDadosProc read getDadosProc write FDadosProc;
    property novaValidade: TIdePeriodo read getNovaValidade write FNovaValidade;
  end;

implementation

uses
  eSocial_Tabelas;

{ TS1070Collection }

function TS1070Collection.Add: TS1070CollectionItem;
begin
  Result := TS1070CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1070Collection.GetItem(Index: Integer): TS1070CollectionItem;
begin
  Result := TS1070CollectionItem(inherited GetItem(Index));
end;

procedure TS1070Collection.SetItem(Index: Integer;
  Value: TS1070CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS1070CollectionItem }

constructor TS1070CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1070;
  FEvtTabProcesso := TEvtTabProcesso.Create(AOwner);
end;

destructor TS1070CollectionItem.Destroy;
begin
  FEvtTabProcesso.Free;
  inherited;
end;

procedure TS1070CollectionItem.setEvtTabProcesso(
  const Value: TEvtTabProcesso);
begin
  FEvtTabProcesso.Assign(Value);
end;

{ TInfoSuspCollection }

function TInfoSuspCollection.Add: TInfoSuspCollectionItem;
begin
  Result := TInfoSuspCollectionItem(inherited Add());
  Result.Create;
end;

constructor TInfoSuspCollection.create(AOwner: TPersistent);
begin
  inherited create(TInfoSuspCollectionItem);
end;

function TInfoSuspCollection.GetItem(
  Index: Integer): TInfoSuspCollectionItem;
begin
  Result := TInfoSuspCollectionItem(Inherited GetItem(Index));
end;

procedure TInfoSuspCollection.SetItem(Index: Integer;
  Value: TInfoSuspCollectionItem);
begin
  Inherited SetItem(Index, Value);
end;


{ TInfoSuspCollectionItem }

constructor TInfoSuspCollectionItem.create;
begin

end;

{ TDadosProc }

constructor TDadosProc.create;
begin
  fDadosProcJud := nil;
  FInfoSusp := nil;
end;

function TDadosProc.dadosProcJudInst: Boolean;
begin
  Result := Assigned(fDadosProcJud);
end;

destructor TDadosProc.destroy;
begin
  FreeAndNil(fDadosProcJud);
  FreeAndNil(FInfoSusp);
  inherited;
end;

function TDadosProc.getDadosProcJud: TDadosProcJud;
begin
  if Not(Assigned(fDadosProcJud)) then
    fDadosProcJud := TDadosProcJud.Create;
  Result := fDadosProcJud;
end;

function TDadosProc.getInfoSusp: TInfoSuspCollection;
begin
  if Not(Assigned(FInfoSusp)) then
    FInfoSusp := TInfoSuspCollection.Create(FInfoSusp);
  Result := FInfoSusp;
end;

function TDadosProc.infoSuspInst: Boolean;
begin
  Result := Assigned(FInfoSusp);
end;

{ TInfoProcesso }

constructor TInfoProcesso.create;
begin
  FIdeProcesso := TIdeProcesso.Create;
  FDadosProc := nil;
  FNovaValidade := nil;
end;

function TInfoProcesso.dadosProcsInst: Boolean;
begin
  Result := Assigned(FDadosProc);
end;

destructor TInfoProcesso.destroy;
begin
  FIdeProcesso.Free;
  FreeAndNil(FDadosProc);
  FreeAndNil(FNovaValidade);
  inherited;
end;

function TInfoProcesso.getDadosProc: TdadosProc;
begin
  if Not(Assigned(FDadosProc)) then
    FdadosProc := TDadosProc.create;
  Result := FDadosProc;
end;

function TInfoProcesso.getNovaValidade: TIdePeriodo;
begin
  if Not(Assigned(FNovaValidade)) then
    FNovaValidade := TIdePeriodo.Create;
  Result := FNovaValidade;
end;

function TInfoProcesso.novaValidadeInst: Boolean;
begin
  Result := Assigned(FNovaValidade);
end;

{ TEvtTabProcesso }

constructor TEvtTabProcesso.Create(AACBreSocial: TObject);
begin
  inherited;
  fIdeEvento := TIdeEvento.Create;
  fIdeEmpregador := TIdeEmpregador.Create;
  fInfoProcesso := TInfoProcesso.Create;
end;

destructor TEvtTabProcesso.Destroy;
begin
  fIdeEvento.Free;
  fIdeEmpregador.Free;
  fInfoProcesso.Free;
  inherited;
end;

procedure TEvtTabProcesso.gerarDadosInfoSusp;
var
  i: Integer;
begin
  if InfoProcesso.dadosProc.infoSuspInst() then
    for i := 0 to InfoProcesso.dadosProc.infoSusp.Count - 1 do
    begin
      Gerador.wGrupo('infoSusp');
        Gerador.wCampo(tcInt, '', 'codSusp', 0, 0, 0, InfoProcesso.dadosProc.infoSusp.GetItem(i).codSusp);
        Gerador.wCampo(tcStr, '', 'indSusp', 0, 0, 0, eSIndSuspToStr(InfoProcesso.dadosProc.infoSusp.GetItem(i).indSusp));
        Gerador.wCampo(tcDat, '', 'dtDecisao', 0, 0, 0, InfoProcesso.dadosProc.infoSusp.GetItem(i).dtDecisao);
        Gerador.wCampo(tcStr, '', 'indDeposito', 0, 0, 0, eSSimNaoToStr(InfoProcesso.dadosProc.infoSusp.GetItem(i).indDeposito));
      Gerador.wGrupo('/infoSusp');
    end;
end;

procedure TEvtTabProcesso.gerarDadosProc;
begin
  Gerador.wGrupo('dadosProc');
    Gerador.wCampo(tcInt, '', 'indAutoria', 0, 0, 0, eSindAutoriaToStr(InfoProcesso.dadosProc.indAutoria));
    Gerador.wCampo(tcInt, '', 'indMatProc', 0, 0, 0, eSTpIndMatProcToStr(InfoProcesso.dadosProc.indMatProc));
    gerarDadosProcJud();
    gerarDadosInfoSusp();
  Gerador.wGrupo('/dadosProc');
end;

procedure TEvtTabProcesso.gerarDadosProcJud;
begin
  if (InfoProcesso.dadosProc.dadosProcJudInst()) then
  begin
    Gerador.wGrupo('dadosProcJud');
      Gerador.wCampo(tcStr, '', 'ufVara', 0, 0, 0, self.InfoProcesso.dadosProc.DadosProcJud.ufVara);
      Gerador.wCampo(tcStr, '', 'codMunic', 0, 0, 0, self.InfoProcesso.dadosProc.DadosProcJud.codMunic);
      Gerador.wCampo(tcStr, '', 'idVara', 0, 0, 0, self.InfoProcesso.dadosProc.DadosProcJud.idVara);
    Gerador.wGrupo('/dadosProcJud');
  end;
end;

procedure TEvtTabProcesso.gerarIdeProcesso;
begin
  Gerador.wGrupo('ideProcesso');
    Gerador.wCampo(tcStr, '', 'tpProc', 0, 0, 0, eSTpProcessoToStr(self.InfoProcesso.ideProcesso.tpProc));
    Gerador.wCampo(tcStr, '', 'nrProc', 0, 0, 0, self.InfoProcesso.ideProcesso.nrProc);
    Gerador.wCampo(tcStr, '', 'iniValid', 0, 0, 0, self.InfoProcesso.ideProcesso.iniValid);
    Gerador.wCampo(tcStr, '', 'fimValid', 0, 0, 0, self.InfoProcesso.ideProcesso.fimValid);
  Gerador.wGrupo('/ideProcesso');
end;

function TEvtTabProcesso.GerarXML: boolean;
begin
  try
    gerarCabecalho('evtTabProcesso');
      Gerador.wGrupo('evtTabProcesso Id="'+ GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0) +'"');
        //gerarIdVersao(self);
        gerarIdeEvento(self.IdeEvento);
        gerarIdeEmpregador(self.IdeEmpregador);
        Gerador.wGrupo('infoProcesso');
          gerarModoAbertura(Self.ModoLancamento);
            gerarIdeProcesso();
            if Self.ModoLancamento <> mlExclusao then
            begin
              gerarDadosProc();
              if Self.ModoLancamento = mlAlteracao then
                if (InfoProcesso.novaValidadeInst()) then
                  GerarIdePeriodo(self.InfoProcesso.NovaValidade,'novaValidade');
            end;
          gerarModoFechamento(Self.ModoLancamento);
        Gerador.wGrupo('/infoProcesso');
      Gerador.wGrupo('/evtTabProcesso');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtTabProcesso');
    Validar('evtTabProcesso');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

end.
