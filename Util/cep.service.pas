unit cep.service;

interface

uses System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param, System.Classes, System.Net.HttpClient;

type
  TCEPService = class

  public
    function ConsultaCep(Cep: string; FormatoJSON: Boolean): string;
    function ConsultaEndereco(Logradouro, Cidade, Estado: string; FormatoJSON: Boolean): string;

  end;

implementation

uses System.JSON;

{ TCEPService }

function TCEPService.ConsultaCEP(Cep: string; FormatoJSON: Boolean): string;
var HTTPClient: THTTPClient;
    Response, URL: string;
    ResponseStream: TStringStream;
    JSONValue: TJSONValue;
    JSONObject: TJSONObject;
begin
  HTTPClient := THTTPClient.Create;
  ResponseStream := TStringStream.Create;
  JSONValue := TJSONValue.Create;
  try
    if Length(Cep) < 8 then
      raise Exception.Create('CEP inválido!');

    // URL da consulta no ViaCEP
    URL := Format('https://viacep.com.br/ws/%s/json/', [Cep]);

    // Faz a requisição ao web service
    HTTPClient.Get(URL, ResponseStream);
    Response := ResponseStream.DataString;

    // Faz o parsing da resposta JSON
    JSONValue := TJSONObject.ParseJSONValue(Response);
    if Assigned(JSONValue) and (JSONValue is TJSONObject) then
    begin
      JSONObject := JSONValue as TJSONObject;
      if JSONObject.GetValue('erro') <> nil then
      begin
        Result := '';
        Exit;
      end;
    end;
    Result := Response;
  finally
    HTTPClient.Free;
    ResponseStream.Free;
    JSONValue.Free;
  end;
end;

function TCEPService.ConsultaEndereco(Logradouro, Cidade, Estado: string; FormatoJSON: Boolean): string;
var
  HTTPClient: THTTPClient;
  Response, URL: string;
  ResponseStream: TStringStream;
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
begin
  HTTPClient := THTTPClient.Create;
  ResponseStream := TStringStream.Create;
  try
    if (Length(Logradouro) < 3) or (Length(Cidade) < 3) or (Length(Estado) < 2) then
      raise Exception.Create('Parâmetros de endereço inválidos! Verifique o Logradouro, Localidade ou UF ');

    // URL de consulta da API ViaCEP
    URL := Format('https://viacep.com.br/ws/%s/%s/%s/json/', [Estado, Cidade, Logradouro]);

    // Faz a requisição ao web service
    HTTPClient.Get(URL, ResponseStream);
    Response := ResponseStream.DataString;

    // Faz o parsing da resposta JSON
    JSONValue := TJSONObject.ParseJSONValue(Response);
    if Assigned(JSONValue) then
    begin
      if JSONValue is TJSONArray then
      begin
        JSONArray := JSONValue as TJSONArray;
        if JSONArray.Count = 0 then
        begin
          Result := '';
          Exit;
        end;

        JSONObject := JSONArray.Items[0] as TJSONObject;
        if JSONObject.GetValue('erro') <> nil then
        begin
          Result := '';
          Exit;
        end;
      end
      else if JSONValue is TJSONObject then
      begin
        JSONObject := JSONValue as TJSONObject;
        if JSONObject.GetValue('erro') <> nil then
        begin
          Result := '';
          Exit;
        end;
      end;
    end;
    Result := Response;
  finally
    HTTPClient.Free;
    ResponseStream.Free;
    JSONValue.Free;
  end;
end;

end.
