// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accessDeniedActionNotAllowed =>
      'Access denied: your role does not allow this action.';

  @override
  String get accessDeniedPageUnavailable =>
      'Access denied: this page is not available for your role.';

  @override
  String get accountCreatedConfirmEmail =>
      'Account created. Confirm your email before signing in.';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully.';

  @override
  String get actions => 'Actions';

  @override
  String get actionsColumnHint =>
      'View, edit, and delete are in the last column.';

  @override
  String get activeModules => 'Active modules';

  @override
  String addEntityToTable(Object entity) {
    return 'Add a new $entity to the table.';
  }

  @override
  String fieldRequired(Object field) {
    return '$field is required';
  }

  @override
  String get addNew => 'Add new';

  @override
  String get appBarBehavior => 'App bar behavior';

  @override
  String get appTitle => 'Store Management';

  @override
  String get apply => 'Apply';

  @override
  String get arabic => 'العربية';

  @override
  String get authOperationFailed => 'Authentication failed. Please try again.';

  @override
  String get availablePlatformsSubtitle =>
      'Continue your work across desktop, mobile, and web using the same account.';

  @override
  String get availablePlatformsTitle => 'Available at';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get batchNumberLabel => 'Batch number';

  @override
  String get bodyFontFamily => 'Mulish';

  @override
  String get branchUuidLabel => 'Branch UUID';

  @override
  String get branches => 'Branches';

  @override
  String get cancel => 'Cancel';

  @override
  String get catalog => 'Catalog';

  @override
  String get catalogSummary =>
      'Keep products, categories, tags, and supplier-specific inventory organized from one place.';

  @override
  String get categories => 'Categories';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get clients => 'Clients';

  @override
  String get close => 'Close';

  @override
  String get closeAll => 'Close all';

  @override
  String get closeAllTabsQuestion => 'Danger: Close all tabs?';

  @override
  String get closeAllUnpinnedTabs => 'Close all unpinned tabs';

  @override
  String get closeAnyway => 'Close anyway';

  @override
  String get closeApplicationQuestion => 'Close application?';

  @override
  String get closeApplicationWarning =>
      'Any unsaved data will be lost if you close the app now.';

  @override
  String get closeTabAction => 'Close tab';

  @override
  String get closeTabQuestion => 'Close tab?';

  @override
  String closeTabWarning(Object tab) {
    return '\"$tab\" will be closed and data in this tab may be unsaved.';
  }

  @override
  String get closeTabsToRight => 'Close tabs to the right';

  @override
  String get collapseAll => 'Collapse all';

  @override
  String get completeConfirmation => 'Complete confirmation';

  @override
  String get completeResetPassword => 'Update password';

  @override
  String confirmEmailDescription(Object email) {
    return 'We sent a confirmation link to $email. Open the link in your email to verify your account.';
  }

  @override
  String get confirmEmailPasteHint =>
      'If confirmation does not complete automatically, copy the final link from your browser and paste it here.';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get confirmYourEmail => 'Confirm your email';

  @override
  String confirmationEmailResent(Object email) {
    return 'Confirmation email sent again to $email.';
  }

  @override
  String get confirmationLink => 'Confirmation link';

  @override
  String get confirmationLinkFullRequired =>
      'Paste the full confirmation link from your email.';

  @override
  String get confirmationLinkHint =>
      'https://...token_hash=... or https://...code=...';

  @override
  String get confirmationLinkMissingDetails =>
      'The confirmation link is missing the required verification details.';

  @override
  String get confirmationLinkRequired =>
      'Paste the confirmation link from your email.';

  @override
  String conflictedRecords(Object count) {
    return 'Conflicted records: $count';
  }

  @override
  String get connectedWorkspace =>
      'Your workspace now surfaces the full product, sales, people, and operations stack from one compact control center.';

  @override
  String get connectionSQLite => 'SQLite (Drift)';

  @override
  String get connectionStatusChecking => 'Checking';

  @override
  String get connectionStatusConnected => 'Connected';

  @override
  String get connectionStatusDisconnected => 'Disconnected';

  @override
  String connectionStatusTooltip(Object source, Object status) {
    return '$source: $status';
  }

  @override
  String get connectionSupabase => 'Supabase';

  @override
  String get continueLabel => 'Continue';

  @override
  String get createAccount => 'Create account';

  @override
  String createEntity(Object entity) {
    return 'Create $entity';
  }

  @override
  String get createdAt => 'Created at';

  @override
  String get customers => 'Customers';

  @override
  String get dangerCloseAllUnpinnedTabsQuestion =>
      'Danger: Close all unpinned tabs?';

  @override
  String get dangerCloseAllUnpinnedTabsWarning => 'These pages will be closed:';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get dashboard => 'Dashboard';

  @override
  String dataTableTitle(Object title) {
    return '$title Datatable';
  }

  @override
  String get deleteLabel => 'Delete';

  @override
  String deleteEntityMessage(Object entity) {
    return 'The selected $entity will be removed.';
  }

  @override
  String deleteEntityQuestion(Object entity) {
    return 'Delete $entity?';
  }

  @override
  String deletedEntitySuccessfully(Object entity) {
    return 'Deleted $entity successfully.';
  }

  @override
  String get displayFontFamily => 'Mulish';

  @override
  String editEntity(Object entity) {
    return 'Edit $entity';
  }

  @override
  String get email => 'Email';

  @override
  String get emailAndPasswordRequired => 'Email and password are required.';

  @override
  String get emailConfirmedSignIn => 'Email confirmed. Sign in to continue.';

  @override
  String get emailConfirmedSuccessfully => 'Email confirmed successfully.';

  @override
  String get emailHint => 'name@store.com';

  @override
  String get english => 'English';

  @override
  String entityDetails(Object entity) {
    return '$entity Details';
  }

  @override
  String get expandAll => 'Expand all';

  @override
  String get expiryDateFormatError => 'Expiry date must use YYYY-MM-DD format.';

  @override
  String get expiryDateLabel => 'Expiry date (YYYY-MM-DD)';

  @override
  String fieldMustBeInteger(Object field) {
    return '$field must be an integer';
  }

  @override
  String fieldMustBeNumber(Object field) {
    return '$field must be a number';
  }

  @override
  String fieldMustUseDateTimeFormat(Object field) {
    return '$field must use YYYY-MM-DD or YYYY-MM-DD HH:MM';
  }

  @override
  String get forgotPasswordAction => 'Forgot password?';

  @override
  String get forgotPasswordDescription =>
      'Enter your email address and we will send you a link to reset your password.';

  @override
  String get forgotPasswordTitle => 'Forgot password?';

  @override
  String get hideAppBarOnScroll => 'Hide app bar on scroll down';

  @override
  String get hideCreate => 'Hide create';

  @override
  String get inventory => 'Inventory';

  @override
  String get invoiceItems => 'Invoice items';

  @override
  String get invoices => 'Invoices';

  @override
  String get language => 'Language';

  @override
  String latestConflictAt(Object dateTime) {
    return 'Latest conflict at: $dateTime';
  }

  @override
  String get lightMode => 'Light mode';

  @override
  String get logout => 'Logout';

  @override
  String get logoutQuestion => 'Sign out?';

  @override
  String get logoutWarning =>
      'You will need to sign in again to continue using the workspace.';

  @override
  String get menu => 'Menu';

  @override
  String get moduleContentEmpty => 'Empty';

  @override
  String get moduleContentEmptyCaption =>
      'Add forms, tables, and filters here next.';

  @override
  String get moduleContentTitle => 'Content';

  @override
  String get modulePlannedSections => 'Planned sections';

  @override
  String get moduleStatusReady => 'Ready';

  @override
  String get moduleStatusReadyCaption =>
      'Navigation is active and this screen is connected.';

  @override
  String get moduleStatusTitle => 'Status';

  @override
  String get moveTabLeft => 'Move tab left';

  @override
  String get moveTabRight => 'Move tab right';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'Store owner name';

  @override
  String get nameRequired => 'Name is required.';

  @override
  String get nextPage => 'Next page';

  @override
  String get noDataAvailable => 'No data available.';

  @override
  String get noMatchingRecords => 'No records match the current search.';

  @override
  String noSyncDelegateAvailable(Object entity) {
    return 'No sync delegate available for $entity.';
  }

  @override
  String get noValueSelected => 'No value selected';

  @override
  String get openDashboard => 'Open dashboard';

  @override
  String openTabsTooltip(Object count) {
    return 'Open tabs ($count)';
  }

  @override
  String get openVisualPermissionEditor => 'Open visual permission editor';

  @override
  String get operations => 'Operations';

  @override
  String get operationsSummary =>
      'Monitor stock movement, financial activity, stores, and reporting from the same dashboard.';

  @override
  String get overview => 'Overview';

  @override
  String get ownerUuidLabel => 'Owner UUID';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'At least 6 characters';

  @override
  String passwordResetInstructionsSent(Object email) {
    return 'Password reset instructions sent to $email.';
  }

  @override
  String get passwordTooShort => 'Password must be at least 6 characters.';

  @override
  String get passwordUpdatedSuccessfully => 'Password updated successfully.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get paymentAllocations => 'Payment allocations';

  @override
  String get paymentVouchers => 'Payment vouchers';

  @override
  String get people => 'People';

  @override
  String get peopleSummary =>
      'Manage customers, clients, users, and role assignments as one connected team layer.';

  @override
  String get permissionEditorTitle => 'Permission editor';

  @override
  String get pinTab => 'Pin tab';

  @override
  String get platformAndroid => 'Android';

  @override
  String get platformIos => 'iOS';

  @override
  String get platformLinux => 'Linux';

  @override
  String get platformMacos => 'macOS';

  @override
  String get platformWeb => 'Web';

  @override
  String get platformWindows => 'Windows';

  @override
  String get postPurchaseReceipt => 'Post purchase receipt';

  @override
  String get posting => 'Posting...';

  @override
  String get previousPage => 'Previous page';

  @override
  String get productUuidLabel => 'Product UUID';

  @override
  String get products => 'Products';

  @override
  String purchaseReceiptPostFailed(Object error) {
    return 'Failed to post purchase receipt: $error';
  }

  @override
  String purchaseReceiptPosted(Object batchUuid) {
    return 'Purchase receipt posted. Batch: $batchUuid';
  }

  @override
  String get purchaseReceiving => 'Purchase receiving';

  @override
  String get purchaseReceivingDescription =>
      'Create inventory batch and post purchase receipt in one action.';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get readyToManage => 'Ready to manage';

  @override
  String get recentEmails => 'Recent emails';

  @override
  String get recommended => 'Recommended';

  @override
  String get recommendedLabel => 'Recommended:';

  @override
  String get recordSyncedSuccessfully => 'Record synced successfully.';

  @override
  String recordsHeader(Object entity) {
    return '$entity records';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get reports => 'Reports';

  @override
  String get resendEmail => 'Resend email';

  @override
  String get reset => 'Reset';

  @override
  String get resetLink => 'Reset link';

  @override
  String get resetLinkFullRequired =>
      'Paste the full password reset link from your email.';

  @override
  String get resetLinkHint =>
      'https://...token_hash=... or https://...code=...';

  @override
  String get resetLinkMissingDetails =>
      'The password reset link is missing the required verification details.';

  @override
  String get resetLinkRequired =>
      'Paste the password reset link from your email.';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordPasteHint =>
      'Paste the password reset link from your email, then choose a new password.';

  @override
  String resetPasswordSentDescription(Object email) {
    return 'A reset link was sent to $email. Use the link in your email to choose a new password.';
  }

  @override
  String get returnItems => 'Return items';

  @override
  String get returns => 'Returns';

  @override
  String get roles => 'Roles';

  @override
  String get rows => 'Rows';

  @override
  String get rowsPerPage => 'Rows per page';

  @override
  String get sales => 'Sales';

  @override
  String get salesSummary =>
      'Track invoices, returns, and payment workflows without digging through separate screens.';

  @override
  String saveEntity(Object entity) {
    return 'Save $entity';
  }

  @override
  String savedEntitySuccessfully(Object entity) {
    return 'Saved $entity successfully.';
  }

  @override
  String get scrollLeft => 'Scroll left';

  @override
  String get scrollRight => 'Scroll right';

  @override
  String get searchAction => 'Search';

  @override
  String get searchPermissions => 'Search permissions';

  @override
  String get searchPermissionsHint => 'Search by key or label';

  @override
  String get searchTable => 'Search table';

  @override
  String get searchTableHint => 'Search across the visible columns.';

  @override
  String get sendAgain => 'Send again';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get settings => 'Settings';

  @override
  String get showCreate => 'Show create';

  @override
  String get showOrHideCreateForm => 'Show or hide the create form.';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInFooter => 'Sign in with your email and password.';

  @override
  String get signInSubtitle => 'Use your email and password to continue.';

  @override
  String get signUp => 'Sign up';

  @override
  String get signUpFooter => 'Enter your details below to create your account.';

  @override
  String get signUpSubtitle => 'Create your account to get started.';

  @override
  String get signedInAs => 'Signed in as';

  @override
  String get signedInFallback => 'You are signed in.';

  @override
  String get signedInSuccessfully => 'Signed in successfully.';

  @override
  String get stackTraceLabel => 'Stack trace';

  @override
  String get staffUserUuidLabel => 'Staff user UUID';

  @override
  String get startupConfigurationError => 'Startup configuration error';

  @override
  String get startupRecoveryDesktop =>
      'On desktop, keeping .env.local.json in the project root also works as a runtime fallback.';

  @override
  String get startupRecoveryMobile =>
      'On mobile, the app cannot read .env.local.json directly from the project root at runtime.';

  @override
  String get startupRecoveryMobileHint =>
      'Use the VS Code launch profile \"store_management (env)\" or pass --dart-define/--dart-define-from-file manually.';

  @override
  String get startupRecoveryProvideKeys =>
      'Provide SUPABASE_URL and SUPABASE_ANON_KEY at launch time.';

  @override
  String get stickyAppBar => 'Sticky app bar';

  @override
  String get storageHybrid => 'Online + local';

  @override
  String get storageHybridDescription =>
      'Supabase stays authoritative for auth and sync while SQLite caches locally for offline-first access. Connectivity failures queue local changes for later reconciliation, and this is the recommended mode.';

  @override
  String get storageLocalOnly => 'Local only';

  @override
  String get storageLocalOnlyDescription =>
      'Keep data only on this device in SQLite. This is fastest and fully offline, but it has no cross-device sync, real-time updates, or centralized control.';

  @override
  String get storageOnlineOnly => 'Online only';

  @override
  String get storageOnlineOnlyDescription =>
      'Supabase is the single source of truth. This simplifies storage flow, but it depends on network access and can add latency on larger operations.';

  @override
  String get storagePreference => 'Storage preference';

  @override
  String get storeBranches => 'Store branches';

  @override
  String get storeSuppliers => 'Store suppliers';

  @override
  String get storeUsers => 'Store users';

  @override
  String get storeUuidLabel => 'Store UUID';

  @override
  String get stores => 'Stores';

  @override
  String get supplierInvoiceUuidLabel => 'Supplier invoice UUID';

  @override
  String get supplierProducts => 'Supplier products';

  @override
  String get supplierUuidLabel => 'Supplier UUID';

  @override
  String get suppliers => 'Suppliers';

  @override
  String get sync => 'Sync';

  @override
  String get syncAll => 'Sync all';

  @override
  String get syncConflictDiagnostics => 'Sync conflict diagnostics';

  @override
  String get syncConflictOverrodePendingLocalEdits =>
      'Remote changes overrode pending local edits.';

  @override
  String get synced => 'Synced';

  @override
  String syncedRecords(Object count) {
    return 'Synced $count records.';
  }

  @override
  String get systemMode => 'System mode';

  @override
  String get tags => 'Tags';

  @override
  String get theme => 'Theme';

  @override
  String get transactions => 'Transactions';

  @override
  String get unauthorizedSectionMessage =>
      'You do not have permission to access this section.';

  @override
  String get unitCostLabel => 'Unit cost';

  @override
  String get unknown => 'Unknown';

  @override
  String get unpinTab => 'Unpin tab';

  @override
  String updateEntity(Object entity) {
    return 'Update $entity';
  }

  @override
  String get updatedAt => 'Updated at';

  @override
  String updatedEntitySuccessfully(Object entity) {
    return 'Updated $entity successfully.';
  }

  @override
  String get userRoles => 'User roles';

  @override
  String get username => 'Username';

  @override
  String get usernameHint => 'store_owner';

  @override
  String get usernameInvalid =>
      'Username can use letters, numbers, and underscores only.';

  @override
  String get usernameRequired => 'Username is required.';

  @override
  String get users => 'Users';

  @override
  String get validEmailRequired => 'Enter a valid email address.';

  @override
  String validField(Object field) {
    return 'Enter a valid $field';
  }

  @override
  String get validPositiveNumbersRequired =>
      'Quantity and unit cost must be valid positive numbers.';

  @override
  String viewEntity(Object entity) {
    return 'View $entity';
  }

  @override
  String get welcomeTitle => 'Welcome to Store Management!';
}
