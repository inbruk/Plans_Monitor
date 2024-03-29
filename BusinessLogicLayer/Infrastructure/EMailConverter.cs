﻿using System;
using System.Linq;
using System.Text;
using System.Collections.Generic;

using BusinessLogicLayer.DataTransferObjects;
using BusinessLogicLayer.DataTransferObjects.Dictionaries;
using BusinessLogicLayer.DataTransferObjects.Views;
using BusinessLogicLayer.Tools;
using BusinessLogicLayer.Tools.Holders;

namespace BusinessLogicLayer.Infrastructure
{
    internal class EMailConverter
    {
        private Audit _currentAudit;
        private Remark _currentRemark;
        private CorrectiveAction _correctiveAction;

        private readonly List<DictionaryValue> _tagDictionaryContent;
        private readonly List<DictionaryValue> _convEmailErrors;

        public EMailConverter(Audit currAudit, Remark currRemark, CorrectiveAction currCorrAction)
        {
            _currentAudit = currAudit;
            _currentRemark = currRemark;
            _correctiveAction = currCorrAction;

            DictionaryValueTool dvTool = DictionaryValueToolHolder.Get();
            _tagDictionaryContent = dvTool.ReadSeveralByDicId((int)EnDictionaryId.EMailTemplateTag);
            _convEmailErrors = dvTool.ReadSeveralByDicId((int)EnDictionaryId.EMailConvertingError);
        }

        public void UpdateMainObjects(Audit currAudit, Remark currRemark, CorrectiveAction currCorrAction)
        {
            _currentAudit = currAudit;
            _currentRemark = currRemark;
            _correctiveAction = currCorrAction;
        }

        private int? ConvertString2TagId(string tagStr)
        {
            DictionaryValue dv = _tagDictionaryContent.SingleOrDefault(x => x.Name == tagStr);
            int? tag_id;
            if (dv == null)
                tag_id = null;
            else
                tag_id = dv.Id;
            return tag_id;
        }

        private string ConvertTagId2StringWithValue(int tagId)
        {
            switch (tagId)
            {
                case (int)EnDictionaryValueId.EMailTemplateTag4Audit_Name: return _currentAudit.Name;
                case (int)EnDictionaryValueId.EMailTemplateTag4Audit_Object: return _currentAudit.AuditObjectName;
                case (int)EnDictionaryValueId.EMailTemplateTag4Audit_Period: return _currentAudit.VerificationPeriod;
                case (int)EnDictionaryValueId.EMailTemplateTag4Audit_Ground: return _currentAudit.GroundForVerification;

                case (int)EnDictionaryValueId.EMailTemplateTag4RemarkInternalAudit_ReportSubsNum: return _currentRemark.ReportSubsectionNumber.ToString();
                case (int)EnDictionaryValueId.EMailTemplateTag4RemarkInternalAudit_Description: return _currentRemark.RemarkDescription;
                case (int)EnDictionaryValueId.EMailTemplateTag4RemarkExternalAudit_SectAttach: return _currentRemark.SectionAttachment.ToString();
                case (int)EnDictionaryValueId.EMailTemplateTag4RemarkExternalAudit_ViolaContent: return _currentRemark.ViolationContent;

                case (int)EnDictionaryValueId.EMailTemplateTag4CAInternalAudit_CA: return _correctiveAction.Name;
                case (int)EnDictionaryValueId.EMailTemplateTag4CAInternalAudit_PlanExeDate: return _correctiveAction.PlannedExecutionDate.ToString();
                case (int)EnDictionaryValueId.EMailTemplateTag4CAInternalAudit_ExecOfficer:
                    return _correctiveAction.ExecutiveOfficerFirstName + _correctiveAction.ExecutiveOfficerLastName + _correctiveAction.ExecutiveOfficerPatronymic;
                case (int)EnDictionaryValueId.EMailTemplateTag4CAInternalAudit_FactExePeriod: return _correctiveAction.FactPeriodOfCAExecution;
                case (int)EnDictionaryValueId.EMailTemplateTag4CAExternalAudit_CA: return _correctiveAction.Name;
                case (int)EnDictionaryValueId.EMailTemplateTag4CAExternalAudit_PlanExeDate: return _correctiveAction.PlannedExecutionDate.ToString();
                case (int)EnDictionaryValueId.EMailTemplateTag4CAExternalAudit_ExecOfficer:
                    return _correctiveAction.ExecutiveOfficerFirstName + _correctiveAction.ExecutiveOfficerLastName + _correctiveAction.ExecutiveOfficerPatronymic;
                case (int)EnDictionaryValueId.EMailTemplateTag4CAExternalAudit_FactExePeriod: return _correctiveAction.FactPeriodOfCAExecution;

                default: return null;
            }
        }

        private enum EnControlSymbol
        {
            LeftCurlyBracket = 0,
            RightCurlyBracket = 1,
            Space = 2,
            EndOfLine = 3,
            EndOfMessage = 4
        }

        private struct NextControlSymbolAndPos
        {
            public EnControlSymbol NextControlSymbol;
            // public int Position;
            public string BeforeSubstring;
            public string AfterSubstring;
        }

        private NextControlSymbolAndPos Scan4NextControlSymbol( string theRestOfTheMessage )
        {
            NextControlSymbolAndPos result = new NextControlSymbolAndPos();
            result.NextControlSymbol = EnControlSymbol.EndOfMessage; // перестраховка

            int i;
            int length = theRestOfTheMessage.Length;
            bool exitCycle = false;
            for (i=0; i<length-1; i++)
            {
                Char currChar = theRestOfTheMessage[i];
                switch (currChar)
                {
                    case '{': result.NextControlSymbol = EnControlSymbol.LeftCurlyBracket; exitCycle = true; break;
                    case '}': result.NextControlSymbol = EnControlSymbol.RightCurlyBracket; exitCycle = true; break;
                    case ' ': result.NextControlSymbol = EnControlSymbol.Space; exitCycle = true; break;
                    case '\n': result.NextControlSymbol = EnControlSymbol.EndOfLine; exitCycle = true; break;
                    default : break;
                }

                if (exitCycle == true)
                {
                    break; // exit from cycle
                }
            }
            if ( i == length-1 ) result.NextControlSymbol = EnControlSymbol.EndOfMessage;

            result.BeforeSubstring = theRestOfTheMessage.Substring(0, i);
            result.AfterSubstring = theRestOfTheMessage.Substring(i+1, length-(i+1) );

            return result;
        }       

        public EMailConverterResult ConvertTemplate2Mail(string template)
        {
            string remainedTemplatePart = string.Copy(template);
            bool tagStarted = false;
            int row = 1;
            int column = 1;

            string producedEMail = "";
            while( true )
            {
                NextControlSymbolAndPos currItem = Scan4NextControlSymbol(remainedTemplatePart);
                remainedTemplatePart = currItem.AfterSubstring;

                // тег уже был начат и это не завершение тега 
                // тег не был начат и это начало тега
                if ( (tagStarted == true && currItem.NextControlSymbol != EnControlSymbol.RightCurlyBracket) || 
                     (tagStarted == false && currItem.NextControlSymbol == EnControlSymbol.RightCurlyBracket)
                   )
                {
                    producedEMail += currItem.BeforeSubstring;
                    column += currItem.BeforeSubstring.Length;

                    string errText;
                    if (
                        currItem.NextControlSymbol == EnControlSymbol.EndOfLine ||
                        currItem.NextControlSymbol == EnControlSymbol.EndOfMessage ||
                        currItem.NextControlSymbol == EnControlSymbol.Space
                    )
                        errText = _convEmailErrors.SingleOrDefault(x => x.Id == (int)EnDictionaryValueId.EMailConverterError_TagTerminatedBySpaceOrEof).Name;
                    else
                        errText = _convEmailErrors.SingleOrDefault(x => x.Id == (int)EnDictionaryValueId.EMailConverterError_TagNotFinishedProperly).Name;

                    return new EMailConverterResult(errText, row, column, template, producedEMail);
                }
                else
                {
                    // нет ни одного тега до конца сообщения (и тег не начат)
                    if (currItem.NextControlSymbol == EnControlSymbol.EndOfMessage)
                    {
                        producedEMail += currItem.BeforeSubstring;
                        column += currItem.BeforeSubstring.Length;
                        return new EMailConverterResult(null, row, column, template, producedEMail);
                    }

                    // нет тегов до конца строки, тогда просто переносим кусок строки и добавляем символ конца строки (и тег не начат)
                    if (currItem.NextControlSymbol == EnControlSymbol.EndOfLine)
                    {
                        producedEMail += currItem.BeforeSubstring;
                        producedEMail += "\n"; // так как символ был удален внутри Scan4NextControlSymbol()
                        row++;
                        column = 1;
                        continue;
                    }

                    // нет тегов до пробела, тогда просто переносим кусок строки и добавляем символ пробела (и тег не начат)
                    if (currItem.NextControlSymbol == EnControlSymbol.Space)
                    {
                        producedEMail += currItem.BeforeSubstring;
                        producedEMail += " "; // так как символ был удален внутри Scan4NextControlSymbol()
                        column += (currItem.BeforeSubstring.Length + 1);
                        continue;
                    }

                    // попался тег начала  (а тег не начат)
                    if (currItem.NextControlSymbol == EnControlSymbol.LeftCurlyBracket)
                    {
                        producedEMail += currItem.BeforeSubstring;
                        column += (currItem.BeforeSubstring.Length + 1);
                        tagStarted = true; // начинаем тег
                        continue;
                    }

                    // попался тег завершения  (а тег начат)
                    if (currItem.NextControlSymbol == EnControlSymbol.RightCurlyBracket )
                    {
                        int? tagId = ConvertString2TagId(currItem.BeforeSubstring);
                        string replaceString = null;
                        if (tagId != null) replaceString = ConvertTagId2StringWithValue((int)tagId);

                        if (replaceString == null)
                        {
                            string errText = _convEmailErrors.SingleOrDefault(x => x.Id == (int)EnDictionaryValueId.EMailConverterError_TagNotFound).Name;
                            return new EMailConverterResult(errText, row, column, template, producedEMail);
                        }
                        else
                        {
                            producedEMail += replaceString;
                            column += (currItem.BeforeSubstring.Length + 1);
                            tagStarted = false; // заканчиваем тег
                            continue;
                        }
                    }
                }
            }
        }
    }
}
