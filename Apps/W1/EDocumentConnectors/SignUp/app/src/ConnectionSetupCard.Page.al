// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.EServices.EDocumentConnector.SignUp;

using System.Telemetry;
using System.Environment;

page 6380 ConnectionSetupCard
{
    PageType = Card;
    SourceTable = ConnectionSetup;
    ApplicationArea = Basic, Suite;
    UsageCategory = None;
    Caption = 'E-Document External Connection Setup';
    Extensible = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(ClientID; ClientID)
                {
                    Caption = 'Client ID';
                    ToolTip = 'Specifies the client ID token.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    Visible = not IsSaaSInfrastructure;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        Auth.StorageSet(Rec."Client ID", ClientID);
                    end;
                }
                field(ClientSecret; ClientSecret)
                {
                    Caption = 'Client Secret';
                    ToolTip = 'Specifies the client secret token.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    Visible = not IsSaaSInfrastructure;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        Auth.StorageSet(Rec."Client Secret", ClientSecret);
                    end;
                }
                field(ClientTenant; ClientTenant)
                {
                    Caption = 'Client Tenant ID';
                    ToolTip = 'Specifies the client tenant id token.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    Visible = not IsSaaSInfrastructure;

                    trigger OnValidate()
                    begin
                        Auth.StorageSet(Rec."Client Tenant", ClientTenant);
                    end;
                }
                field(RootID; RootID)
                {
                    Caption = 'Root App ID';
                    ToolTip = 'Specifies the root app id token.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    Visible = not IsSaaSInfrastructure;

                    trigger OnValidate()
                    begin
                        Auth.StorageSet(Rec."Root App ID", RootID);
                    end;
                }
                field(RootSecret; RootSecret)
                {
                    Caption = 'Root Secret';
                    ToolTip = 'Specifies the root secret token.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    Visible = not IsSaaSInfrastructure;

                    trigger OnValidate()
                    begin
                        Auth.StorageSet(Rec."Root Secret", RootSecret);
                    end;
                }
                field(RootTenant; RootTenant)
                {
                    Caption = 'Root Tenant ID';
                    ToolTip = 'Specifies the root tenant id token.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    Visible = not IsSaaSInfrastructure;

                    trigger OnValidate()
                    begin
                        Auth.StorageSet(Rec."Root Tenant", RootTenant);
                    end;
                }
                field(RootUrl; RootUrl)
                {
                    Caption = 'Root Url';
                    ToolTip = 'Specifies the root url token.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = Masked;
                    Visible = not IsSaaSInfrastructure;

                    trigger OnValidate()
                    begin
                        Auth.StorageSet(Rec."Root Market URL", RootUrl);
                    end;
                }
                field("Authentication URL"; Rec."Authentication URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the URL to connect Microsoft Entra.';
                }
                field(ServiceURL; Rec.ServiceURL)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the service URL.';
                }
                field("Company Id"; Rec."Company Id")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the company ID.';
                    ShowMandatory = true;
                }
                field("Send Mode"; Rec."Send Mode")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the send mode.';
                    ShowMandatory = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(InitOnboarding01)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Onboarding';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = IsSaaSInfrastructure;
                ToolTip = 'Create client credentials and open the onboarding process in a web browser.';

                trigger OnAction()
                begin
                    Auth.CreateClientCredentials();
                    CurrPage.Update();
                    SetPageVariables();
                    Hyperlink(Auth.GetRootOnboardingUrl());
                    FeatureTelemetry.LogUptake('', ExternalServiceTok, Enum::"Feature Uptake Status"::"Set up");
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        EnvironmentInfo: Codeunit "Environment Information";
    begin
        IsSaaSInfrastructure := EnvironmentInfo.IsSaaSInfrastructure();
        Auth.InitConnectionSetup();
        if Rec.Get() then
            ;
        SetPageVariables();
        FeatureTelemetry.LogUptake('', ExternalServiceTok, Enum::"Feature Uptake Status"::Discovered);
    end;

    local procedure SetPageVariables()
    begin
        if not IsNullGuid(Rec."Client ID") then
            ClientID := '*';
        if not IsNullGuid(Rec."Client Secret") then
            ClientSecret := '*';
        if not IsNullGuid(Rec."Client Tenant") then
            ClientTenant := '*';
        if not IsNullGuid(Rec."Root App ID") then
            RootID := '*';
        if not IsNullGuid(Rec."Root Secret") then
            RootSecret := '*';
        if not IsNullGuid(Rec."Root Tenant") then
            RootTenant := '*';
        if not IsNullGuid(Rec."Root Market URL") then
            RootUrl := '*';
    end;

    var
        Auth: Codeunit Auth;
        FeatureTelemetry: Codeunit "Feature Telemetry";
        [NonDebuggable]
        ClientID, ClientSecret, ClientTenant, ClientUrl, RootID, RootSecret, RootTenant, RootUrl : Text;
        IsSaaSInfrastructure: Boolean;
        ExternalServiceTok: Label 'ExternalServiceConnector', Locked = true;


}