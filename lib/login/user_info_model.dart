import 'dart:convert';

class UserInfotModel {
  User? user;
  String? verification;

  UserInfotModel({
    this.user,
    this.verification,
  });

  factory UserInfotModel.fromRawJson(String str) => UserInfotModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfotModel.fromJson(Map<String, dynamic> json) => UserInfotModel(
    user: User.fromJson(json["user"]),
    verification: json["verification"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "verification": verification,
  };
}

class User {
  int? id;
  dynamic countryId;
  dynamic website;
  dynamic memberId;
  dynamic memberType;
  dynamic lastLoginAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? creationProcessState;
  int? referenceCurrencyId;
  String? username;
  bool? tosAccepted;
  String? email;
  String? role;
  dynamic relationshipManagerId;
  dynamic phoneHome;
  dynamic phoneOffice;
  dynamic fax;
  dynamic address1Street;
  dynamic address1Zipcode;
  dynamic address1CountryId;
  dynamic address2Street;
  dynamic address2Zipcode;
  dynamic address2CountryId;
  dynamic addressOfficeStreet;
  dynamic addressOfficeZipcode;
  dynamic addressOfficeCountryId;
  dynamic professionalGroupId;
  dynamic avatarUid;
  bool? isAdmin;
  dynamic deletedAt;
  dynamic betaAccessCode;
  dynamic paymentUntil;
  dynamic companyName;
  dynamic employer;
  dynamic yearsOfService;
  dynamic education;
  dynamic insiderInCompanies;
  dynamic title;
  dynamic firstName;
  dynamic lastName;
  dynamic phoneMobile;
  String? investglassId;
  bool? isProfessional;
  List<dynamic>? licensedItemsIds;
  int? allowedFunds;
  dynamic fundsGlobalCoverage;
  String? timeZone;
  String? timeFormat;
  String? dateFormat;
  bool? marketingAccepted;
  dynamic marketingAcceptedAt;
  DateTime? tosAcceptedAt;
  int? landingPage;
  dynamic executableCode;
  dynamic calendlyProfile;
  List<dynamic>? colState;
  List<dynamic>? sortState;
  List<dynamic>? daynamicCol;
  AccountFilterState? filterState;
  dynamic personalizedDescription;
  bool? bookMeeting;
  dynamic encryptedOtpSecret;
  dynamic otpVerificationAt;
  dynamic otpBrowser;
  DateTime? passwordChangedAt;
  int? creatorId;
  int? lastModifierId;
  dynamic skypeId;
  dynamic location;
  dynamic dateOfBirth;
  dynamic dateOfWorkAnniversary;
  List<dynamic>? marketColState;
  List<dynamic>? marketSortState;
  List<dynamic>? marketDynamicCol;
  AccountFilterState? marketFilterState;
  List<dynamic>? accountColState;
  List<dynamic>? accountSortState;
  List<dynamic>? accountDynamicCol;
  AccountFilterState? accountFilterState;
  List<dynamic>? relationColState;
  List<dynamic>? relationSortState;
  List<dynamic>? relationDynamicCol;
  AccountFilterState? relationFilterState;
  List<dynamic>? contractColState;
  List<dynamic>? contractSortState;
  List<dynamic>? contractDynamicCol;
  AccountFilterState? contractFilterState;
  List<dynamic>? contactColState;
  List<dynamic>? contactSortState;
  List<dynamic>? contactDynamicCol;
  AccountFilterState? contactFilterState;
  List<dynamic>? notificationColState;
  List<dynamic>? notificationSortState;
  List<dynamic>? notificationDynamicCol;
  AccountFilterState? notificationFilterState;
  dynamic initRecords;
  dynamic accountInitRecords;
  dynamic relationInitRecords;
  dynamic contactInitRecords;
  dynamic contractInitRecords;
  dynamic marketInitRecords;
  dynamic notificationInitRecords;
  AccountFilterState? widgetData;
  List<dynamic>? approvalColState;
  List<dynamic>? approvalSortState;
  List<dynamic>? approvalDynamicCol;
  AccountFilterState? approvalFilterState;
  dynamic approvalInitRecords;
  List<dynamic>? taskColState;
  List<dynamic>? taskSortState;
  AccountFilterState? taskFilterState;
  dynamic taskInitRecords;
  AccountFilterState? currentTemplates;
  dynamic emailSignature;
  AccountFilterState? tasksWidget;
  dynamic address1City;
  AccountFilterState? emailCredentials;
  EncryptedOtpSecretForClient? encryptedOtpSecretForClient;
  AccountFilterState? encryptedOtpSecretForMember;
  dynamic otpVerificationAtClient;
  dynamic status;
  int? workCapacity;
  AccountFilterState? customFields;
  int? companyId;
  int? realAvailableCapacities;
  dynamic recentWorkingDate;
  dynamic uid;
  dynamic provider;
  int? consecutiveLockout;
  String? opportunityColState;
  String? opportunitySortState;
  String? opportunityDynamicCol;
  String? opportunityFilterState;
  dynamic consecutiveLockedAt;
  int? failedSmsAttempts;
  String? portfolioMonitoringColState;
  String? portfolioMonitoringSortState;
  String? portfolioMonitoringDynamicCol;
  String? portfolioMonitoringFilterState;
  String? custodianMonitoringColState;
  String? custodianMonitoringSortState;
  String? custodianMonitoringDynamicCol;
  String? custodianMonitoringFilterState;
  String? callReportsColState;
  String? callReportsSortState;
  String? callReportsDynamicCol;
  String? callReportsFilterState;
  String? otpSecret;
  dynamic consumedTimestep;
  dynamic otpRequiredForLogin;
  AccountFilterState? pdfTemplates;
  DateTime? resetPassAt;
  dynamic availabilityId;
  dynamic taskDynamicCol;
  dynamic otpBackupCodes;
  Client? client;
  Advisor? advisor;

  User({
    this.id,
    this.countryId,
    this.website,
    this.memberId,
    this.memberType,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.creationProcessState,
    this.referenceCurrencyId,
    this.username,
    this.tosAccepted,
    this.email,
    this.role,
    this.relationshipManagerId,
    this.phoneHome,
    this.phoneOffice,
    this.fax,
    this.address1Street,
    this.address1Zipcode,
    this.address1CountryId,
    this.address2Street,
    this.address2Zipcode,
    this.address2CountryId,
    this.addressOfficeStreet,
    this.addressOfficeZipcode,
    this.addressOfficeCountryId,
    this.professionalGroupId,
    this.avatarUid,
    this.isAdmin,
    this.deletedAt,
    this.betaAccessCode,
    this.paymentUntil,
    this.companyName,
    this.employer,
    this.yearsOfService,
    this.education,
    this.insiderInCompanies,
    this.title,
    this.firstName,
    this.lastName,
    this.phoneMobile,
    this.investglassId,
    this.isProfessional,
    this.licensedItemsIds,
    this.allowedFunds,
    this.fundsGlobalCoverage,
    this.timeZone,
    this.timeFormat,
    this.dateFormat,
    this.marketingAccepted,
    this.marketingAcceptedAt,
    this.tosAcceptedAt,
    this.landingPage,
    this.executableCode,
    this.calendlyProfile,
    this.colState,
    this.sortState,
    this.daynamicCol,
    this.filterState,
    this.personalizedDescription,
    this.bookMeeting,
    this.encryptedOtpSecret,
    this.otpVerificationAt,
    this.otpBrowser,
    this.passwordChangedAt,
    this.creatorId,
    this.lastModifierId,
    this.skypeId,
    this.location,
    this.dateOfBirth,
    this.dateOfWorkAnniversary,
    this.marketColState,
    this.marketSortState,
    this.marketDynamicCol,
    this.marketFilterState,
    this.accountColState,
    this.accountSortState,
    this.accountDynamicCol,
    this.accountFilterState,
    this.relationColState,
    this.relationSortState,
    this.relationDynamicCol,
    this.relationFilterState,
    this.contractColState,
    this.contractSortState,
    this.contractDynamicCol,
    this.contractFilterState,
    this.contactColState,
    this.contactSortState,
    this.contactDynamicCol,
    this.contactFilterState,
    this.notificationColState,
    this.notificationSortState,
    this.notificationDynamicCol,
    this.notificationFilterState,
    this.initRecords,
    this.accountInitRecords,
    this.relationInitRecords,
    this.contactInitRecords,
    this.contractInitRecords,
    this.marketInitRecords,
    this.notificationInitRecords,
    this.widgetData,
    this.approvalColState,
    this.approvalSortState,
    this.approvalDynamicCol,
    this.approvalFilterState,
    this.approvalInitRecords,
    this.taskColState,
    this.taskSortState,
    this.taskFilterState,
    this.taskInitRecords,
    this.currentTemplates,
    this.emailSignature,
    this.tasksWidget,
    this.address1City,
    this.emailCredentials,
    this.encryptedOtpSecretForClient,
    this.encryptedOtpSecretForMember,
    this.otpVerificationAtClient,
    this.status,
    this.workCapacity,
    this.customFields,
    this.companyId,
    this.realAvailableCapacities,
    this.recentWorkingDate,
    this.uid,
    this.provider,
    this.consecutiveLockout,
    this.opportunityColState,
    this.opportunitySortState,
    this.opportunityDynamicCol,
    this.opportunityFilterState,
    this.consecutiveLockedAt,
    this.failedSmsAttempts,
    this.portfolioMonitoringColState,
    this.portfolioMonitoringSortState,
    this.portfolioMonitoringDynamicCol,
    this.portfolioMonitoringFilterState,
    this.custodianMonitoringColState,
    this.custodianMonitoringSortState,
    this.custodianMonitoringDynamicCol,
    this.custodianMonitoringFilterState,
    this.callReportsColState,
    this.callReportsSortState,
    this.callReportsDynamicCol,
    this.callReportsFilterState,
    this.otpSecret,
    this.consumedTimestep,
    this.otpRequiredForLogin,
    this.pdfTemplates,
    this.resetPassAt,
    this.availabilityId,
    this.taskDynamicCol,
    this.otpBackupCodes,
    this.client,
    this.advisor,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    countryId: json["country_id"],
    website: json["website"],
    memberId: json["member_id"],
    memberType: json["member_type"],
    lastLoginAt: json["last_login_at"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
    creationProcessState: json["creation_process_state"],
    referenceCurrencyId: json["reference_currency_id"],
    username: json["username"],
    tosAccepted: json["tos_accepted"],
    email: json["email"],
    role: json["role"],
    relationshipManagerId: json["relationship_manager_id"],
    phoneHome: json["phone_home"],
    phoneOffice: json["phone_office"],
    fax: json["fax"],
    address1Street: json["address_1_street"],
    address1Zipcode: json["address_1_zipcode"],
    address1CountryId: json["address_1_country_id"],
    address2Street: json["address_2_street"],
    address2Zipcode: json["address_2_zipcode"],
    address2CountryId: json["address_2_country_id"],
    addressOfficeStreet: json["address_office_street"],
    addressOfficeZipcode: json["address_office_zipcode"],
    addressOfficeCountryId: json["address_office_country_id"],
    professionalGroupId: json["professional_group_id"],
    avatarUid: json["avatar_uid"],
    isAdmin: json["is_admin"],
    deletedAt: json["deleted_at"],
    betaAccessCode: json["beta_access_code"],
    paymentUntil: json["payment_until"],
    companyName: json["company_name"],
    employer: json["employer"],
    yearsOfService: json["years_of_service"],
    education: json["education"],
    insiderInCompanies: json["insider_in_companies"],
    title: json["title"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phoneMobile: json["phone_mobile"],
    investglassId: json["investglass_id"],
    isProfessional: json["is_professional"],
    // licensedItemsIds: List<dynamic>.from(json["licensed_items_ids"].map((x) => x)),
    allowedFunds: json["allowed_funds"],
    fundsGlobalCoverage: json["funds_global_coverage"],
    timeZone: json["time_zone"],
    timeFormat: json["time_format"],
    dateFormat: json["date_format"],
    marketingAccepted: json["marketing_accepted"],
    marketingAcceptedAt: json["marketing_accepted_at"],
    // tosAcceptedAt: DateTime.parse(json["tos_accepted_at"]),
    landingPage: json["landing_page"],
    executableCode: json["executable_code"],
    calendlyProfile: json["calendly_profile"],
    // colState: List<dynamic>.from(json["col_state"].map((x) => x)),
    // sortState: List<dynamic>.from(json["sort_state"].map((x) => x)),
    // daynamicCol: List<dynamic>.from(json["daynamic_col"].map((x) => x)),
    // filterState: AccountFilterState.fromJson(json["filter_state"]),
    personalizedDescription: json["personalized_description"],
    bookMeeting: json["book_meeting"],
    encryptedOtpSecret: json["encrypted_otp_secret"],
    otpVerificationAt: json["otp_verification_at"],
    otpBrowser: json["otp_browser"],
    // passwordChangedAt: DateTime.parse(json["password_changed_at"]),
    creatorId: json["creator_id"],
    lastModifierId: json["last_modifier_id"],
    skypeId: json["skype_id"],
    location: json["location"],
    dateOfBirth: json["date_of_birth"],
    dateOfWorkAnniversary: json["date_of_work_anniversary"],
    // marketColState: List<dynamic>.from(json["market_col_state"].map((x) => x)),
    // marketSortState: List<dynamic>.from(json["market_sort_state"].map((x) => x)),
    // marketDynamicCol: List<dynamic>.from(json["market_dynamic_col"].map((x) => x)),
    // marketFilterState: AccountFilterState.fromJson(json["market_filter_state"]),
    // accountColState: List<dynamic>.from(json["account_col_state"].map((x) => x)),
    // accountSortState: List<dynamic>.from(json["account_sort_state"].map((x) => x)),
    // accountDynamicCol: List<dynamic>.from(json["account_dynamic_col"].map((x) => x)),
    // accountFilterState: AccountFilterState.fromJson(json["account_filter_state"]),
    // relationColState: List<dynamic>.from(json["relation_col_state"].map((x) => x)),
    // relationSortState: List<dynamic>.from(json["relation_sort_state"].map((x) => x)),
    // relationDynamicCol: List<dynamic>.from(json["relation_dynamic_col"].map((x) => x)),
    // relationFilterState: AccountFilterState.fromJson(json["relation_filter_state"]),
    // contractColState: List<dynamic>.from(json["contract_col_state"].map((x) => x)),
    // contractSortState: List<dynamic>.from(json["contract_sort_state"].map((x) => x)),
    // contractDynamicCol: List<dynamic>.from(json["contract_dynamic_col"].map((x) => x)),
    // contractFilterState: AccountFilterState.fromJson(json["contract_filter_state"]),
    // contactColState: List<dynamic>.from(json["contact_col_state"].map((x) => x)),
    // contactSortState: List<dynamic>.from(json["contact_sort_state"].map((x) => x)),
    // contactDynamicCol: List<dynamic>.from(json["contact_dynamic_col"].map((x) => x)),
    // contactFilterState: AccountFilterState.fromJson(json["contact_filter_state"]),
    // notificationColState: List<dynamic>.from(json["notification_col_state"].map((x) => x)),
    // notificationSortState: List<dynamic>.from(json["notification_sort_state"].map((x) => x)),
    // notificationDynamicCol: List<dynamic>.from(json["notification_dynamic_col"].map((x) => x)),
    // notificationFilterState: AccountFilterState.fromJson(json["notification_filter_state"]),
    initRecords: json["init_records"],
    accountInitRecords: json["account_init_records"],
    relationInitRecords: json["relation_init_records"],
    contactInitRecords: json["contact_init_records"],
    contractInitRecords: json["contract_init_records"],
    marketInitRecords: json["market_init_records"],
    notificationInitRecords: json["notification_init_records"],
    // widgetData: AccountFilterState.fromJson(json["widget_data"]),
    // approvalColState: List<dynamic>.from(json["approval_col_state"].map((x) => x)),
    // approvalSortState: List<dynamic>.from(json["approval_sort_state"].map((x) => x)),
    // approvalDynamicCol: List<dynamic>.from(json["approval_dynamic_col"].map((x) => x)),
    // approvalFilterState: AccountFilterState.fromJson(json["approval_filter_state"]),
    approvalInitRecords: json["approval_init_records"],
    // taskColState: List<dynamic>.from(json["task_col_state"].map((x) => x)),
    // taskSortState: List<dynamic>.from(json["task_sort_state"].map((x) => x)),
    // taskFilterState: AccountFilterState.fromJson(json["task_filter_state"]),
    taskInitRecords: json["task_init_records"],
    // currentTemplates: AccountFilterState.fromJson(json["current_templates"]),
    emailSignature: json["email_signature"],
    // tasksWidget: AccountFilterState.fromJson(json["tasks_widget"]),
    address1City: json["address_1_city"],
    // emailCredentials: AccountFilterState.fromJson(json["email_credentials"]),
    // encryptedOtpSecretForClient: EncryptedOtpSecretForClient.fromJson(json["encrypted_otp_secret_for_client"]),
    // encryptedOtpSecretForMember: AccountFilterState.fromJson(json["encrypted_otp_secret_for_member"]),
    otpVerificationAtClient: json["otp_verification_at_client"],
    status: json["status"],
    workCapacity: json["Work_Capacity"],
    customFields: json["custom_fields"]==null?null:AccountFilterState.fromJson(json["custom_fields"]),
    client: json["client"]==null?null:Client.fromJson(json["client"]),
    advisor: json["advisor"]==null?null:Advisor.fromJson(json["advisor"]),
    companyId: json["company_id"],
    realAvailableCapacities: json["real_available_capacities"],
    recentWorkingDate: json["recent_working_date"],
    uid: json["uid"],
    provider: json["provider"],
    consecutiveLockout: json["consecutive_lockout"],
    opportunityColState: json["opportunity_col_state"],
    opportunitySortState: json["opportunity_sort_state"],
    opportunityDynamicCol: json["opportunity_dynamic_col"],
    opportunityFilterState: json["opportunity_filter_state"],
    consecutiveLockedAt: json["consecutive_locked_at"],
    failedSmsAttempts: json["failed_sms_attempts"],
    portfolioMonitoringColState: json["portfolio_monitoring_col_state"],
    portfolioMonitoringSortState: json["portfolio_monitoring_sort_state"],
    portfolioMonitoringDynamicCol: json["portfolio_monitoring_dynamic_col"],
    portfolioMonitoringFilterState: json["portfolio_monitoring_filter_state"],
    custodianMonitoringColState: json["custodian_monitoring_col_state"],
    custodianMonitoringSortState: json["custodian_monitoring_sort_state"],
    custodianMonitoringDynamicCol: json["custodian_monitoring_dynamic_col"],
    custodianMonitoringFilterState: json["custodian_monitoring_filter_state"],
    callReportsColState: json["call_reports_col_state"],
    callReportsSortState: json["call_reports_sort_state"],
    callReportsDynamicCol: json["call_reports_dynamic_col"],
    callReportsFilterState: json["call_reports_filter_state"],
    otpSecret: json["otp_secret"],
    consumedTimestep: json["consumed_timestep"],
    otpRequiredForLogin: json["otp_required_for_login"],
    pdfTemplates: json["pdf_templates"]==null?null:AccountFilterState.fromJson(json["pdf_templates"]),
    // resetPassAt: DateTime.parse(json["reset_pass_at"]),
    availabilityId: json["availability_id"],
    taskDynamicCol: json["task_dynamic_col"],
    otpBackupCodes: json["otp_backup_codes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "website": website,
    "member_id": memberId,
    "member_type": memberType,
    "last_login_at": lastLoginAt,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
    "creation_process_state": creationProcessState,
    "reference_currency_id": referenceCurrencyId,
    "username": username,
    "tos_accepted": tosAccepted,
    "email": email,
    "role": role,
    "relationship_manager_id": relationshipManagerId,
    "phone_home": phoneHome,
    "phone_office": phoneOffice,
    "fax": fax,
    "address_1_street": address1Street,
    "address_1_zipcode": address1Zipcode,
    "address_1_country_id": address1CountryId,
    "address_2_street": address2Street,
    "address_2_zipcode": address2Zipcode,
    "address_2_country_id": address2CountryId,
    "address_office_street": addressOfficeStreet,
    "address_office_zipcode": addressOfficeZipcode,
    "address_office_country_id": addressOfficeCountryId,
    "professional_group_id": professionalGroupId,
    "avatar_uid": avatarUid,
    "is_admin": isAdmin,
    "deleted_at": deletedAt,
    "beta_access_code": betaAccessCode,
    "payment_until": paymentUntil,
    "company_name": companyName,
    "employer": employer,
    "years_of_service": yearsOfService,
    "education": education,
    "insider_in_companies": insiderInCompanies,
    "title": title,
    "first_name": firstName,
    "last_name": lastName,
    "phone_mobile": phoneMobile,
    "investglass_id": investglassId,
    "is_professional": isProfessional,
    // "licensed_items_ids": List<dynamic>.from(licensedItemsIds.map((x) => x)),
    "allowed_funds": allowedFunds,
    "funds_global_coverage": fundsGlobalCoverage,
    "time_zone": timeZone,
    "time_format": timeFormat,
    "date_format": dateFormat,
    "marketing_accepted": marketingAccepted,
    "marketing_accepted_at": marketingAcceptedAt,
    // "tos_accepted_at": tosAcceptedAt.toIso8601String(),
    "landing_page": landingPage,
    "executable_code": executableCode,
    "calendly_profile": calendlyProfile,
    // "col_state": List<dynamic>.from(colState.map((x) => x)),
    // "sort_state": List<dynamic>.from(sortState.map((x) => x)),
    // "daynamic_col": List<dynamic>.from(daynamicCol.map((x) => x)),
    // "filter_state": filterState.toJson(),
    "personalized_description": personalizedDescription,
    "book_meeting": bookMeeting,
    "encrypted_otp_secret": encryptedOtpSecret,
    "otp_verification_at": otpVerificationAt,
    "otp_browser": otpBrowser,
    // "password_changed_at": passwordChangedAt.toIso8601String(),
    "creator_id": creatorId,
    "last_modifier_id": lastModifierId,
    "skype_id": skypeId,
    "location": location,
    "date_of_birth": dateOfBirth,
    "date_of_work_anniversary": dateOfWorkAnniversary,
    /*"market_col_state": List<dynamic>.from(marketColState.map((x) => x)),
    "market_sort_state": List<dynamic>.from(marketSortState.map((x) => x)),
    "market_dynamic_col": List<dynamic>.from(marketDynamicCol.map((x) => x)),
    "market_filter_state": marketFilterState.toJson(),
    "account_col_state": List<dynamic>.from(accountColState.map((x) => x)),
    "account_sort_state": List<dynamic>.from(accountSortState.map((x) => x)),
    "account_dynamic_col": List<dynamic>.from(accountDynamicCol.map((x) => x)),
    "account_filter_state": accountFilterState.toJson(),
    "relation_col_state": List<dynamic>.from(relationColState.map((x) => x)),
    "relation_sort_state": List<dynamic>.from(relationSortState.map((x) => x)),
    "relation_dynamic_col": List<dynamic>.from(relationDynamicCol.map((x) => x)),
    "relation_filter_state": relationFilterState.toJson(),
    "contract_col_state": List<dynamic>.from(contractColState.map((x) => x)),
    "contract_sort_state": List<dynamic>.from(contractSortState.map((x) => x)),
    "contract_dynamic_col": List<dynamic>.from(contractDynamicCol.map((x) => x)),
    "contract_filter_state": contractFilterState.toJson(),
    "contact_col_state": List<dynamic>.from(contactColState.map((x) => x)),
    "contact_sort_state": List<dynamic>.from(contactSortState.map((x) => x)),
    "contact_dynamic_col": List<dynamic>.from(contactDynamicCol.map((x) => x)),
    "contact_filter_state": contactFilterState.toJson(),
    "notification_col_state": List<dynamic>.from(notificationColState.map((x) => x)),
    "notification_sort_state": List<dynamic>.from(notificationSortState.map((x) => x)),
    "notification_dynamic_col": List<dynamic>.from(notificationDynamicCol.map((x) => x)),
    "notification_filter_state": notificationFilterState.toJson(),*/
    "init_records": initRecords,
    "account_init_records": accountInitRecords,
    "relation_init_records": relationInitRecords,
    "contact_init_records": contactInitRecords,
    "contract_init_records": contractInitRecords,
    "market_init_records": marketInitRecords,
    "notification_init_records": notificationInitRecords,
    "widget_data": widgetData?.toJson(),
    // "approval_col_state": List<dynamic>.from(approvalColState.map((x) => x)),
    // "approval_sort_state": List<dynamic>.from(approvalSortState.map((x) => x)),
    // "approval_dynamic_col": List<dynamic>.from(approvalDynamicCol.map((x) => x)),
    "approval_filter_state": approvalFilterState?.toJson(),
    "approval_init_records": approvalInitRecords,
    // "task_col_state": List<dynamic>.from(taskColState.map((x) => x)),
    // "task_sort_state": List<dynamic>.from(taskSortState.map((x) => x)),
    "task_filter_state": taskFilterState?.toJson(),
    "task_init_records": taskInitRecords,
    "current_templates": currentTemplates?.toJson(),
    "email_signature": emailSignature,
    "tasks_widget": tasksWidget?.toJson(),
    "address_1_city": address1City,
    "email_credentials": emailCredentials?.toJson(),
    "encrypted_otp_secret_for_client": encryptedOtpSecretForClient?.toJson(),
    "encrypted_otp_secret_for_member": encryptedOtpSecretForMember?.toJson(),
    "otp_verification_at_client": otpVerificationAtClient,
    "status": status,
    "Work_Capacity": workCapacity,
    "custom_fields": customFields?.toJson(),
    "company_id": companyId,
    "real_available_capacities": realAvailableCapacities,
    "recent_working_date": recentWorkingDate,
    "uid": uid,
    "provider": provider,
    "consecutive_lockout": consecutiveLockout,
    "opportunity_col_state": opportunityColState,
    "opportunity_sort_state": opportunitySortState,
    "opportunity_dynamic_col": opportunityDynamicCol,
    "opportunity_filter_state": opportunityFilterState,
    "consecutive_locked_at": consecutiveLockedAt,
    "failed_sms_attempts": failedSmsAttempts,
    "portfolio_monitoring_col_state": portfolioMonitoringColState,
    "portfolio_monitoring_sort_state": portfolioMonitoringSortState,
    "portfolio_monitoring_dynamic_col": portfolioMonitoringDynamicCol,
    "portfolio_monitoring_filter_state": portfolioMonitoringFilterState,
    "custodian_monitoring_col_state": custodianMonitoringColState,
    "custodian_monitoring_sort_state": custodianMonitoringSortState,
    "custodian_monitoring_dynamic_col": custodianMonitoringDynamicCol,
    "custodian_monitoring_filter_state": custodianMonitoringFilterState,
    "call_reports_col_state": callReportsColState,
    "call_reports_sort_state": callReportsSortState,
    "call_reports_dynamic_col": callReportsDynamicCol,
    "call_reports_filter_state": callReportsFilterState,
    "otp_secret": otpSecret,
    "consumed_timestep": consumedTimestep,
    "otp_required_for_login": otpRequiredForLogin,
    // "pdf_templates": pdfTemplates.toJson(),
    // "reset_pass_at": resetPassAt.toIso8601String(),
    "availability_id": availabilityId,
    "task_dynamic_col": taskDynamicCol,
    "otp_backup_codes": otpBackupCodes,
    "client": client?.toJson(),
    "advisor": advisor?.toJson(),
  };
}

class AccountFilterState {
  AccountFilterState();

  factory AccountFilterState.fromRawJson(String str) => AccountFilterState.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountFilterState.fromJson(Map<String, dynamic> json) => AccountFilterState(
  );

  Map<String, dynamic> toJson() => {
  };
}

class EncryptedOtpSecretForClient {
  String? sms;
  String? email;
  DateTime? smsTime;
  DateTime? emailTime;

  EncryptedOtpSecretForClient({
    this.sms,
    this.email,
    this.smsTime,
    this.emailTime,
  });

  factory EncryptedOtpSecretForClient.fromRawJson(String str) => EncryptedOtpSecretForClient.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EncryptedOtpSecretForClient.fromJson(Map<String, dynamic> json) => EncryptedOtpSecretForClient(
    sms: json["sms"],
    email: json["email"],
    smsTime: DateTime.parse(json["sms_time"]),
    emailTime: DateTime.parse(json["email_time"]),
  );

  Map<String, dynamic> toJson() => {
    "sms": sms,
    "email": email,
    // "sms_time": smsTime.toIso8601String(),
    // "email_time": emailTime.toIso8601String(),
  };
}

class Client {
  int? id;

  Client({
    this.id,
  });

  factory Client.fromRawJson(String str) => Client.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };

}

class Advisor {
  int? id;
  String? name;
  String? phoneMobile;
  String? phoneHome;
  String? phoneOffice;
  String? email;
  String? avatar;
  String? publicAgenda;

  factory Advisor.fromRawJson(String str) => Advisor.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Advisor.fromJson(Map<String, dynamic> json) => Advisor(
    id: json["id"],
    name: json["name"],
    phoneMobile: json["phone_mobile"],
    phoneHome: json["phone_home"],
    phoneOffice: json["phone_office"],
    email: json["email"],
    avatar: json["avatar"],
    publicAgenda: json["public_agenda"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone_mobile": phoneMobile,
    "phone_home": phoneHome,
    "phone_office": phoneOffice,
    "email": email,
    "avatar": avatar,
    "public_agenda": publicAgenda,
  };

  Advisor({
    this.id,
    this.name,
    this.phoneMobile,
    this.phoneHome,
    this.phoneOffice,
    this.email,
    this.avatar,
    this.publicAgenda,
  });

}
