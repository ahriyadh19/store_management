import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @accessDeniedActionNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Access denied: your role does not allow this action.'**
  String get accessDeniedActionNotAllowed;

  /// No description provided for @accessDeniedPageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Access denied: this page is not available for your role.'**
  String get accessDeniedPageUnavailable;

  /// No description provided for @accountCreatedConfirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Account created. Confirm your email before signing in.'**
  String get accountCreatedConfirmEmail;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get accountCreatedSuccessfully;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @actionsColumnHint.
  ///
  /// In en, this message translates to:
  /// **'View, edit, and delete are in the last column.'**
  String get actionsColumnHint;

  /// No description provided for @activeModules.
  ///
  /// In en, this message translates to:
  /// **'Active modules'**
  String get activeModules;

  /// No description provided for @addEntityToTable.
  ///
  /// In en, this message translates to:
  /// **'Add a new {entity} to the table.'**
  String addEntityToTable(Object entity);

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String fieldRequired(Object field);

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// No description provided for @appBarBehavior.
  ///
  /// In en, this message translates to:
  /// **'App bar behavior'**
  String get appBarBehavior;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Management'**
  String get appTitle;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @authOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get authOperationFailed;

  /// No description provided for @availablePlatformsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your work across desktop, mobile, and web using the same account.'**
  String get availablePlatformsSubtitle;

  /// No description provided for @availablePlatformsTitle.
  ///
  /// In en, this message translates to:
  /// **'Available at'**
  String get availablePlatformsTitle;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @batchNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Batch number'**
  String get batchNumberLabel;

  /// No description provided for @bodyFontFamily.
  ///
  /// In en, this message translates to:
  /// **'Mulish'**
  String get bodyFontFamily;

  /// No description provided for @branchUuidLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch UUID'**
  String get branchUuidLabel;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalog;

  /// No description provided for @catalogSummary.
  ///
  /// In en, this message translates to:
  /// **'Keep products, categories, tags, and supplier-specific inventory organized from one place.'**
  String get catalogSummary;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @closeAll.
  ///
  /// In en, this message translates to:
  /// **'Close all'**
  String get closeAll;

  /// No description provided for @closeAllTabsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Danger: Close all tabs?'**
  String get closeAllTabsQuestion;

  /// No description provided for @closeAllUnpinnedTabs.
  ///
  /// In en, this message translates to:
  /// **'Close all unpinned tabs'**
  String get closeAllUnpinnedTabs;

  /// No description provided for @closeAnyway.
  ///
  /// In en, this message translates to:
  /// **'Close anyway'**
  String get closeAnyway;

  /// No description provided for @closeApplicationQuestion.
  ///
  /// In en, this message translates to:
  /// **'Close application?'**
  String get closeApplicationQuestion;

  /// No description provided for @closeApplicationWarning.
  ///
  /// In en, this message translates to:
  /// **'Any unsaved data will be lost if you close the app now.'**
  String get closeApplicationWarning;

  /// No description provided for @closeTabAction.
  ///
  /// In en, this message translates to:
  /// **'Close tab'**
  String get closeTabAction;

  /// No description provided for @closeTabQuestion.
  ///
  /// In en, this message translates to:
  /// **'Close tab?'**
  String get closeTabQuestion;

  /// No description provided for @closeTabWarning.
  ///
  /// In en, this message translates to:
  /// **'\"{tab}\" will be closed and data in this tab may be unsaved.'**
  String closeTabWarning(Object tab);

  /// No description provided for @closeTabsToRight.
  ///
  /// In en, this message translates to:
  /// **'Close tabs to the right'**
  String get closeTabsToRight;

  /// No description provided for @collapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse all'**
  String get collapseAll;

  /// No description provided for @completeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Complete confirmation'**
  String get completeConfirmation;

  /// No description provided for @completeResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get completeResetPassword;

  /// No description provided for @confirmEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {email}. Open the link in your email to verify your account.'**
  String confirmEmailDescription(Object email);

  /// No description provided for @confirmEmailPasteHint.
  ///
  /// In en, this message translates to:
  /// **'If confirmation does not complete automatically, copy the final link from your browser and paste it here.'**
  String get confirmEmailPasteHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @confirmYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email'**
  String get confirmYourEmail;

  /// No description provided for @confirmationEmailResent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent again to {email}.'**
  String confirmationEmailResent(Object email);

  /// No description provided for @confirmationLink.
  ///
  /// In en, this message translates to:
  /// **'Confirmation link'**
  String get confirmationLink;

  /// No description provided for @confirmationLinkFullRequired.
  ///
  /// In en, this message translates to:
  /// **'Paste the full confirmation link from your email.'**
  String get confirmationLinkFullRequired;

  /// No description provided for @confirmationLinkHint.
  ///
  /// In en, this message translates to:
  /// **'https://...token_hash=... or https://...code=...'**
  String get confirmationLinkHint;

  /// No description provided for @confirmationLinkMissingDetails.
  ///
  /// In en, this message translates to:
  /// **'The confirmation link is missing the required verification details.'**
  String get confirmationLinkMissingDetails;

  /// No description provided for @confirmationLinkRequired.
  ///
  /// In en, this message translates to:
  /// **'Paste the confirmation link from your email.'**
  String get confirmationLinkRequired;

  /// No description provided for @conflictedRecords.
  ///
  /// In en, this message translates to:
  /// **'Conflicted records: {count}'**
  String conflictedRecords(Object count);

  /// No description provided for @connectedWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Your workspace now surfaces the full product, sales, people, and operations stack from one compact control center.'**
  String get connectedWorkspace;

  /// No description provided for @connectionSQLite.
  ///
  /// In en, this message translates to:
  /// **'SQLite (Drift)'**
  String get connectionSQLite;

  /// No description provided for @connectionStatusChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get connectionStatusChecking;

  /// No description provided for @connectionStatusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connectionStatusConnected;

  /// No description provided for @connectionStatusDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get connectionStatusDisconnected;

  /// No description provided for @connectionStatusTooltip.
  ///
  /// In en, this message translates to:
  /// **'{source}: {status}'**
  String connectionStatusTooltip(Object source, Object status);

  /// No description provided for @connectionSupabase.
  ///
  /// In en, this message translates to:
  /// **'Supabase'**
  String get connectionSupabase;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createEntity.
  ///
  /// In en, this message translates to:
  /// **'Create {entity}'**
  String createEntity(Object entity);

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get createdAt;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @dangerCloseAllUnpinnedTabsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Danger: Close all unpinned tabs?'**
  String get dangerCloseAllUnpinnedTabsQuestion;

  /// No description provided for @dangerCloseAllUnpinnedTabsWarning.
  ///
  /// In en, this message translates to:
  /// **'These pages will be closed:'**
  String get dangerCloseAllUnpinnedTabsWarning;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @dataTableTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} Datatable'**
  String dataTableTitle(Object title);

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @deleteEntityMessage.
  ///
  /// In en, this message translates to:
  /// **'The selected {entity} will be removed.'**
  String deleteEntityMessage(Object entity);

  /// No description provided for @deleteEntityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete {entity}?'**
  String deleteEntityQuestion(Object entity);

  /// No description provided for @deletedEntitySuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted {entity} successfully.'**
  String deletedEntitySuccessfully(Object entity);

  /// No description provided for @displayFontFamily.
  ///
  /// In en, this message translates to:
  /// **'Mulish'**
  String get displayFontFamily;

  /// No description provided for @editEntity.
  ///
  /// In en, this message translates to:
  /// **'Edit {entity}'**
  String editEntity(Object entity);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailAndPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password are required.'**
  String get emailAndPasswordRequired;

  /// No description provided for @emailConfirmedSignIn.
  ///
  /// In en, this message translates to:
  /// **'Email confirmed. Sign in to continue.'**
  String get emailConfirmedSignIn;

  /// No description provided for @emailConfirmedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Email confirmed successfully.'**
  String get emailConfirmedSuccessfully;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@store.com'**
  String get emailHint;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @entityDetails.
  ///
  /// In en, this message translates to:
  /// **'{entity} Details'**
  String entityDetails(Object entity);

  /// No description provided for @expandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand all'**
  String get expandAll;

  /// No description provided for @expiryDateFormatError.
  ///
  /// In en, this message translates to:
  /// **'Expiry date must use YYYY-MM-DD format.'**
  String get expiryDateFormatError;

  /// No description provided for @expiryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry date (YYYY-MM-DD)'**
  String get expiryDateLabel;

  /// No description provided for @fieldMustBeInteger.
  ///
  /// In en, this message translates to:
  /// **'{field} must be an integer'**
  String fieldMustBeInteger(Object field);

  /// No description provided for @fieldMustBeNumber.
  ///
  /// In en, this message translates to:
  /// **'{field} must be a number'**
  String fieldMustBeNumber(Object field);

  /// No description provided for @fieldMustUseDateTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'{field} must use YYYY-MM-DD or YYYY-MM-DD HH:MM'**
  String fieldMustUseDateTimeFormat(Object field);

  /// No description provided for @forgotPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordAction;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordTitle;

  /// No description provided for @hideAppBarOnScroll.
  ///
  /// In en, this message translates to:
  /// **'Hide app bar on scroll down'**
  String get hideAppBarOnScroll;

  /// No description provided for @hideCreate.
  ///
  /// In en, this message translates to:
  /// **'Hide create'**
  String get hideCreate;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @invoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Invoice items'**
  String get invoiceItems;

  /// No description provided for @invoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @latestConflictAt.
  ///
  /// In en, this message translates to:
  /// **'Latest conflict at: {dateTime}'**
  String latestConflictAt(Object dateTime);

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get logoutQuestion;

  /// No description provided for @logoutWarning.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to continue using the workspace.'**
  String get logoutWarning;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @moduleContentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get moduleContentEmpty;

  /// No description provided for @moduleContentEmptyCaption.
  ///
  /// In en, this message translates to:
  /// **'Add forms, tables, and filters here next.'**
  String get moduleContentEmptyCaption;

  /// No description provided for @moduleContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get moduleContentTitle;

  /// No description provided for @modulePlannedSections.
  ///
  /// In en, this message translates to:
  /// **'Planned sections'**
  String get modulePlannedSections;

  /// No description provided for @moduleStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get moduleStatusReady;

  /// No description provided for @moduleStatusReadyCaption.
  ///
  /// In en, this message translates to:
  /// **'Navigation is active and this screen is connected.'**
  String get moduleStatusReadyCaption;

  /// No description provided for @moduleStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get moduleStatusTitle;

  /// No description provided for @moveTabLeft.
  ///
  /// In en, this message translates to:
  /// **'Move tab left'**
  String get moveTabLeft;

  /// No description provided for @moveTabRight.
  ///
  /// In en, this message translates to:
  /// **'Move tab right'**
  String get moveTabRight;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Store owner name'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get nameRequired;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get noDataAvailable;

  /// No description provided for @noMatchingRecords.
  ///
  /// In en, this message translates to:
  /// **'No records match the current search.'**
  String get noMatchingRecords;

  /// No description provided for @noSyncDelegateAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sync delegate available for {entity}.'**
  String noSyncDelegateAvailable(Object entity);

  /// No description provided for @noValueSelected.
  ///
  /// In en, this message translates to:
  /// **'No value selected'**
  String get noValueSelected;

  /// No description provided for @openDashboard.
  ///
  /// In en, this message translates to:
  /// **'Open dashboard'**
  String get openDashboard;

  /// No description provided for @openTabsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open tabs ({count})'**
  String openTabsTooltip(Object count);

  /// No description provided for @openVisualPermissionEditor.
  ///
  /// In en, this message translates to:
  /// **'Open visual permission editor'**
  String get openVisualPermissionEditor;

  /// No description provided for @operations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operations;

  /// No description provided for @operationsSummary.
  ///
  /// In en, this message translates to:
  /// **'Monitor stock movement, financial activity, stores, and reporting from the same dashboard.'**
  String get operationsSummary;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @ownerUuidLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner UUID'**
  String get ownerUuidLabel;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordHint;

  /// No description provided for @passwordResetInstructionsSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset instructions sent to {email}.'**
  String passwordResetInstructionsSent(Object email);

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully.'**
  String get passwordUpdatedSuccessfully;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @paymentAllocations.
  ///
  /// In en, this message translates to:
  /// **'Payment allocations'**
  String get paymentAllocations;

  /// No description provided for @paymentVouchers.
  ///
  /// In en, this message translates to:
  /// **'Payment vouchers'**
  String get paymentVouchers;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @peopleSummary.
  ///
  /// In en, this message translates to:
  /// **'Manage customers, clients, users, and role assignments as one connected team layer.'**
  String get peopleSummary;

  /// No description provided for @permissionEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission editor'**
  String get permissionEditorTitle;

  /// No description provided for @pinTab.
  ///
  /// In en, this message translates to:
  /// **'Pin tab'**
  String get pinTab;

  /// No description provided for @platformAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get platformAndroid;

  /// No description provided for @platformIos.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get platformIos;

  /// No description provided for @platformLinux.
  ///
  /// In en, this message translates to:
  /// **'Linux'**
  String get platformLinux;

  /// No description provided for @platformMacos.
  ///
  /// In en, this message translates to:
  /// **'macOS'**
  String get platformMacos;

  /// No description provided for @platformWeb.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get platformWeb;

  /// No description provided for @platformWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get platformWindows;

  /// No description provided for @postPurchaseReceipt.
  ///
  /// In en, this message translates to:
  /// **'Post purchase receipt'**
  String get postPurchaseReceipt;

  /// No description provided for @posting.
  ///
  /// In en, this message translates to:
  /// **'Posting...'**
  String get posting;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @productUuidLabel.
  ///
  /// In en, this message translates to:
  /// **'Product UUID'**
  String get productUuidLabel;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @purchaseReceiptPostFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to post purchase receipt: {error}'**
  String purchaseReceiptPostFailed(Object error);

  /// No description provided for @purchaseReceiptPosted.
  ///
  /// In en, this message translates to:
  /// **'Purchase receipt posted. Batch: {batchUuid}'**
  String purchaseReceiptPosted(Object batchUuid);

  /// No description provided for @purchaseReceiving.
  ///
  /// In en, this message translates to:
  /// **'Purchase receiving'**
  String get purchaseReceiving;

  /// No description provided for @purchaseReceivingDescription.
  ///
  /// In en, this message translates to:
  /// **'Create inventory batch and post purchase receipt in one action.'**
  String get purchaseReceivingDescription;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @readyToManage.
  ///
  /// In en, this message translates to:
  /// **'Ready to manage'**
  String get readyToManage;

  /// No description provided for @recentEmails.
  ///
  /// In en, this message translates to:
  /// **'Recent emails'**
  String get recentEmails;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @recommendedLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended:'**
  String get recommendedLabel;

  /// No description provided for @recordSyncedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Record synced successfully.'**
  String get recordSyncedSuccessfully;

  /// No description provided for @recordsHeader.
  ///
  /// In en, this message translates to:
  /// **'{entity} records'**
  String recordsHeader(Object entity);

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmail;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetLink.
  ///
  /// In en, this message translates to:
  /// **'Reset link'**
  String get resetLink;

  /// No description provided for @resetLinkFullRequired.
  ///
  /// In en, this message translates to:
  /// **'Paste the full password reset link from your email.'**
  String get resetLinkFullRequired;

  /// No description provided for @resetLinkHint.
  ///
  /// In en, this message translates to:
  /// **'https://...token_hash=... or https://...code=...'**
  String get resetLinkHint;

  /// No description provided for @resetLinkMissingDetails.
  ///
  /// In en, this message translates to:
  /// **'The password reset link is missing the required verification details.'**
  String get resetLinkMissingDetails;

  /// No description provided for @resetLinkRequired.
  ///
  /// In en, this message translates to:
  /// **'Paste the password reset link from your email.'**
  String get resetLinkRequired;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the password reset link from your email, then choose a new password.'**
  String get resetPasswordPasteHint;

  /// No description provided for @resetPasswordSentDescription.
  ///
  /// In en, this message translates to:
  /// **'A reset link was sent to {email}. Use the link in your email to choose a new password.'**
  String resetPasswordSentDescription(Object email);

  /// No description provided for @returnItems.
  ///
  /// In en, this message translates to:
  /// **'Return items'**
  String get returnItems;

  /// No description provided for @returns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get returns;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @rows.
  ///
  /// In en, this message translates to:
  /// **'Rows'**
  String get rows;

  /// No description provided for @rowsPerPage.
  ///
  /// In en, this message translates to:
  /// **'Rows per page'**
  String get rowsPerPage;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @salesSummary.
  ///
  /// In en, this message translates to:
  /// **'Track invoices, returns, and payment workflows without digging through separate screens.'**
  String get salesSummary;

  /// No description provided for @saveEntity.
  ///
  /// In en, this message translates to:
  /// **'Save {entity}'**
  String saveEntity(Object entity);

  /// No description provided for @savedEntitySuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved {entity} successfully.'**
  String savedEntitySuccessfully(Object entity);

  /// No description provided for @scrollLeft.
  ///
  /// In en, this message translates to:
  /// **'Scroll left'**
  String get scrollLeft;

  /// No description provided for @scrollRight.
  ///
  /// In en, this message translates to:
  /// **'Scroll right'**
  String get scrollRight;

  /// No description provided for @searchAction.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchAction;

  /// No description provided for @searchPermissions.
  ///
  /// In en, this message translates to:
  /// **'Search permissions'**
  String get searchPermissions;

  /// No description provided for @searchPermissionsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by key or label'**
  String get searchPermissionsHint;

  /// No description provided for @searchTable.
  ///
  /// In en, this message translates to:
  /// **'Search table'**
  String get searchTable;

  /// No description provided for @searchTableHint.
  ///
  /// In en, this message translates to:
  /// **'Search across the visible columns.'**
  String get searchTableHint;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get sendAgain;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @showCreate.
  ///
  /// In en, this message translates to:
  /// **'Show create'**
  String get showCreate;

  /// No description provided for @showOrHideCreateForm.
  ///
  /// In en, this message translates to:
  /// **'Show or hide the create form.'**
  String get showOrHideCreateForm;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInFooter.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your email and password.'**
  String get signInFooter;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your email and password to continue.'**
  String get signInSubtitle;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signUpFooter.
  ///
  /// In en, this message translates to:
  /// **'Enter your details below to create your account.'**
  String get signUpFooter;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started.'**
  String get signUpSubtitle;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get signedInAs;

  /// No description provided for @signedInFallback.
  ///
  /// In en, this message translates to:
  /// **'You are signed in.'**
  String get signedInFallback;

  /// No description provided for @signedInSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully.'**
  String get signedInSuccessfully;

  /// No description provided for @stackTraceLabel.
  ///
  /// In en, this message translates to:
  /// **'Stack trace'**
  String get stackTraceLabel;

  /// No description provided for @staffUserUuidLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff user UUID'**
  String get staffUserUuidLabel;

  /// No description provided for @startupConfigurationError.
  ///
  /// In en, this message translates to:
  /// **'Startup configuration error'**
  String get startupConfigurationError;

  /// No description provided for @startupRecoveryDesktop.
  ///
  /// In en, this message translates to:
  /// **'On desktop, keeping .env.local.json in the project root also works as a runtime fallback.'**
  String get startupRecoveryDesktop;

  /// No description provided for @startupRecoveryMobile.
  ///
  /// In en, this message translates to:
  /// **'On mobile, the app cannot read .env.local.json directly from the project root at runtime.'**
  String get startupRecoveryMobile;

  /// No description provided for @startupRecoveryMobileHint.
  ///
  /// In en, this message translates to:
  /// **'Use the VS Code launch profile \"store_management (env)\" or pass --dart-define/--dart-define-from-file manually.'**
  String get startupRecoveryMobileHint;

  /// No description provided for @startupRecoveryProvideKeys.
  ///
  /// In en, this message translates to:
  /// **'Provide SUPABASE_URL and SUPABASE_ANON_KEY at launch time.'**
  String get startupRecoveryProvideKeys;

  /// No description provided for @stickyAppBar.
  ///
  /// In en, this message translates to:
  /// **'Sticky app bar'**
  String get stickyAppBar;

  /// No description provided for @storageHybrid.
  ///
  /// In en, this message translates to:
  /// **'Online + local'**
  String get storageHybrid;

  /// No description provided for @storageHybridDescription.
  ///
  /// In en, this message translates to:
  /// **'Supabase stays authoritative for auth and sync while SQLite caches locally for offline-first access. Connectivity failures queue local changes for later reconciliation, and this is the recommended mode.'**
  String get storageHybridDescription;

  /// No description provided for @storageLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Local only'**
  String get storageLocalOnly;

  /// No description provided for @storageLocalOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep data only on this device in SQLite. This is fastest and fully offline, but it has no cross-device sync, real-time updates, or centralized control.'**
  String get storageLocalOnlyDescription;

  /// No description provided for @storageOnlineOnly.
  ///
  /// In en, this message translates to:
  /// **'Online only'**
  String get storageOnlineOnly;

  /// No description provided for @storageOnlineOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Supabase is the single source of truth. This simplifies storage flow, but it depends on network access and can add latency on larger operations.'**
  String get storageOnlineOnlyDescription;

  /// No description provided for @storagePreference.
  ///
  /// In en, this message translates to:
  /// **'Storage preference'**
  String get storagePreference;

  /// No description provided for @storeBranches.
  ///
  /// In en, this message translates to:
  /// **'Store branches'**
  String get storeBranches;

  /// No description provided for @storeSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Store suppliers'**
  String get storeSuppliers;

  /// No description provided for @storeUsers.
  ///
  /// In en, this message translates to:
  /// **'Store users'**
  String get storeUsers;

  /// No description provided for @storeUuidLabel.
  ///
  /// In en, this message translates to:
  /// **'Store UUID'**
  String get storeUuidLabel;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @supplierInvoiceUuidLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplier invoice UUID'**
  String get supplierInvoiceUuidLabel;

  /// No description provided for @supplierProducts.
  ///
  /// In en, this message translates to:
  /// **'Supplier products'**
  String get supplierProducts;

  /// No description provided for @supplierUuidLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplier UUID'**
  String get supplierUuidLabel;

  /// No description provided for @suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @syncAll.
  ///
  /// In en, this message translates to:
  /// **'Sync all'**
  String get syncAll;

  /// No description provided for @syncConflictDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Sync conflict diagnostics'**
  String get syncConflictDiagnostics;

  /// No description provided for @syncConflictOverrodePendingLocalEdits.
  ///
  /// In en, this message translates to:
  /// **'Remote changes overrode pending local edits.'**
  String get syncConflictOverrodePendingLocalEdits;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @syncedRecords.
  ///
  /// In en, this message translates to:
  /// **'Synced {count} records.'**
  String syncedRecords(Object count);

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System mode'**
  String get systemMode;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @unauthorizedSectionMessage.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access this section.'**
  String get unauthorizedSectionMessage;

  /// No description provided for @unitCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit cost'**
  String get unitCostLabel;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unpinTab.
  ///
  /// In en, this message translates to:
  /// **'Unpin tab'**
  String get unpinTab;

  /// No description provided for @updateEntity.
  ///
  /// In en, this message translates to:
  /// **'Update {entity}'**
  String updateEntity(Object entity);

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at'**
  String get updatedAt;

  /// No description provided for @updatedEntitySuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated {entity} successfully.'**
  String updatedEntitySuccessfully(Object entity);

  /// No description provided for @userRoles.
  ///
  /// In en, this message translates to:
  /// **'User roles'**
  String get userRoles;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'store_owner'**
  String get usernameHint;

  /// No description provided for @usernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Username can use letters, numbers, and underscores only.'**
  String get usernameInvalid;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required.'**
  String get usernameRequired;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @validEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validEmailRequired;

  /// No description provided for @validField.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid {field}'**
  String validField(Object field);

  /// No description provided for @validPositiveNumbersRequired.
  ///
  /// In en, this message translates to:
  /// **'Quantity and unit cost must be valid positive numbers.'**
  String get validPositiveNumbersRequired;

  /// No description provided for @viewEntity.
  ///
  /// In en, this message translates to:
  /// **'View {entity}'**
  String viewEntity(Object entity);

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Store Management!'**
  String get welcomeTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
