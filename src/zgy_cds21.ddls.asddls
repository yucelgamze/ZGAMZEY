@AbapCatalog.sqlViewName: 'ZGY_CDS21'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds21'
define view zgy_DDL21
  as select from I_SalesDocumentBasic
{
  SalesDocument,
  SDDocumentCategory,
  SalesDocumentType,
  SalesDocumentProcessingType,
  CreatedByUser,
  CreationDate,
  CreationTime,
  LastChangeDate,
  LastChangeDateTime,
  SalesOrganization,
  DistributionChannel,
  OrganizationDivision,
  SalesGroup,
  SalesOffice,
  SoldToParty,
  AdditionalCustomerGroup1,
  AdditionalCustomerGroup2,
  AdditionalCustomerGroup3,
  AdditionalCustomerGroup4,
  AdditionalCustomerGroup5,
  CreditControlArea,
  CustomerRebateAgreement,
  SalesDocumentDate,
  SDDocumentReason,
  SDDocumentCollectiveNumber,
  CustomerPurchaseOrderType,
  CustomerPurchaseOrderDate,
  CustomerPurchaseOrderSuplmnt,
  StatisticsCurrency,
  RetsMgmtProcess,
  BindingPeriodValidityStartDate,
  BindingPeriodValidityEndDate,
  HdrOrderProbabilityInPercent,
  SchedulingAgreementProfileCode,
  AgrmtValdtyStartDate,
  AgrmtValdtyEndDate,
  TotalNetAmount,
  TransactionCurrency,
  SalesDocumentCondition,
  RequestedDeliveryDate,
  ShippingCondition,
  CompleteDeliveryIsDefined,
  DeliveryBlockReason,
  BillingCompanyCode,
  HeaderBillingBlockReason,
  ExchangeRateType,
  BusinessArea,
  CostCenterBusinessArea,
  CostCenter,
  ControllingArea,
  OrderID,
  ControllingObject,
  ReferenceSDDocument,
  ReferenceSDDocumentCategory,
  OverallSDProcessStatus,
  OverallPurchaseConfStatus,
  OverallSDDocumentRejectionSts,
  TotalBlockStatus,
  OverallDelivConfStatus,
  OverallTotalDeliveryStatus,
  OverallDeliveryStatus,
  OverallDeliveryBlockStatus,
  OverallOrdReltdBillgStatus,
  OverallBillingBlockStatus,
  OverallTotalSDDocRefStatus,
  OverallSDDocReferenceStatus,
  TotalCreditCheckStatus,
  MaxDocValueCreditCheckStatus,
  PaymentTermCreditCheckStatus,
  FinDocCreditCheckStatus,
  ExprtInsurCreditCheckStatus,
  PaytAuthsnCreditCheckSts,
  CentralCreditCheckStatus,
  CentralCreditChkTechErrSts,
  HdrGeneralIncompletionStatus,
  OverallPricingIncompletionSts,
  HeaderDelivIncompletionStatus,
  HeaderBillgIncompletionStatus,
  OvrlItmGeneralIncompletionSts,
  OvrlItmBillingIncompletionSts,
  OvrlItmDelivIncompletionSts ,
  ContractManualCompletion
  /* Associations */
  //    _AdditionalCustomerGroup1,
  //    _AdditionalCustomerGroup2,
  //    _AdditionalCustomerGroup3,
  //    _AdditionalCustomerGroup4,
  //    _AdditionalCustomerGroup5,
  //    _BillingCompanyCode,
  //    _BusinessArea,
  //    _CentralCreditCheckStatus,
  //    _CentralCreditChkTechErrSts,
  //    _ControllingArea,
  //    _ControllingObject,
  //    _CostCenter,
  //    _CostCenterBusinessArea,
  //    _CreatedByUser,
  //    _CreditControlArea,
  //    _DeliveryBlockReason,
  //    _DistributionChannel,
  //    _EngagementProjectItem,
  //    _ExchangeRateType,
  //    _ExprtInsurCreditCheckStatus,
  //    _FinDocCreditCheckStatus,
  //    _HdrGeneralIncompletionStatus, 
  //    _HeaderBillgIncompletionStatus,
  //    _HeaderBillingBlockReason,
  //    _HeaderDelivIncompletionStatus,
  //    _ItemBasic,
  //    _MaxDocValueCreditCheckStatus,
  //    _OrganizationDivision,
  //    _OverallBillingBlockStatus,
  //    _OverallDelivConfStatus,
  //    _OverallDeliveryBlockStatus,
  //    _OverallDeliveryStatus,
  //    _OverallOrdReltdBillgStatus,
  //    _OverallPricingIncompletionSts,
  //    _OverallPurchaseConfStatus,
  //    _OverallSDDocReferenceStatus,
  //    _OverallSDDocumentRejectionSts,
  //    _OverallSDProcessStatus,
  //    _OverallTotalDeliveryStatus,
  //    _OverallTotalSDDocRefStatus,
  //    _OvrlItmBillingIncompletionSts,
  //    _OvrlItmDelivIncompletionSts,
  //    _OvrlItmGeneralIncompletionSts,
  //    _Partner,
  //    _PaymentTermCreditCheckStatus,
  //    _PaytAuthsnCreditCheckSts,
  //    _ReferenceSDDocumentCategory,
  //    _RetsMgmtProcess,
  //    _SalesArea,
  //    _SalesDocumentType,
  //    _SalesGroup,
  //    _SalesOffice,
  //    _SalesOrganization,
  //    _SDDocumentCategory,
  //    _SDDocumentReason,
  //    _ShippingCondition,
  //    _SoldToParty,
  //    _StatisticsCurrency,
  //    _TotalBlockStatus,
  //    _TotalCreditCheckStatus,
  //    _TransactionCurrency
}

//STANDART CDS CALLING 
 