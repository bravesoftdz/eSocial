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
|* 01/03/2016: Guilherme Costa
|*  - Passado o namespace para gera��o do cabe�alho
******************************************************************************}
{$I ACBr.inc}

unit eSocial_S1298;

interface

uses
  SysUtils, Classes,
  eSocial_Common, eSocial_Conversao,
  pcnConversao,
  ACBreSocialGerador;

type
  TS1298Collection = class;
  TS1298CollectionItem = class;
  TEvtReabreEvPer = class;

  TS1298Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1298CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1298CollectionItem);
  public
    function Add: TS1298CollectionItem;
    property Items[Index: Integer]: TS1298CollectionItem read GetItem write SetItem; default;
  end;

  TS1298CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtReabreEvPer: TEvtReabreEvPer;
    procedure setEvtReabreEvPer(const Value: TEvtReabreEvPer);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtReabreEvPer: TEvtReabreEvPer read FEvtReabreEvPer write setEvtReabreEvPer;
  end;

  TEvtReabreEvPer = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento4;
    FIdeEmpregador: TIdeEmpregador;
    {Geradores espec�ficos da classe}
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;

    property IdeEvento: TIdeEvento4 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
  end;

implementation

uses
  eSocial_Periodicos;

{ TS1298Collection }
function TS1298Collection.Add: TS1298CollectionItem;
begin
  Result := TS1298CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1298Collection.GetItem(Index: Integer): TS1298CollectionItem;
begin
  Result := TS1298CollectionItem(inherited GetItem(Index));
end;

procedure TS1298Collection.SetItem(Index: Integer; Value: TS1298CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{TS1298CollectionItem}
constructor TS1298CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1298;
  FEvtReabreEvPer := TEvtReabreEvPer.Create(AOwner);
end;

destructor TS1298CollectionItem.Destroy;
begin
  FEvtReabreEvPer.Free;
  inherited;
end;

procedure TS1298CollectionItem.setEvtReabreEvPer(const Value: TEvtReabreEvPer);
begin
  FEvtReabreEvPer.Assign(Value);
end;

{ TEvtSolicTotal }
constructor TEvtReabreEvPer.Create(AACBreSocial: TObject);
begin
  inherited;
  FIdeEvento := TIdeEvento4.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
end;

destructor TEvtReabreEvPer.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  inherited;
end;

function TEvtReabreEvPer.GerarXML: boolean;
begin
  try
    GerarCabecalho('evtReabreEvPer');
      Gerador.wGrupo('evtReabreEvPer Id="'+GerarChaveEsocial(now, self.ideEmpregador.NrInsc, 0)+'"');
        GerarIdeEvento4(self.IdeEvento);
        gerarIdeEmpregador(self.IdeEmpregador);

      Gerador.wGrupo('/evtReabreEvPer');
    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtReabreEvPer');
    Validar('evtReabreEvPer');
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

end.
