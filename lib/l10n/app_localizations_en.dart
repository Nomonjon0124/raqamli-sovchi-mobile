// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get faceCaptureTitle => 'Take one selfie';

  @override
  String get faceCaptureSubtitle =>
      'We compare it with your main photo. No one will see it, and it will be deleted after verification.';

  @override
  String get selfieCameraLabel => 'selfie camera';

  @override
  String get faceRuleOne => 'Place your face inside the circle.';

  @override
  String get faceRuleTwo => 'Make sure your face is visible.';

  @override
  String get faceRuleThree => 'Hold the phone at eye level.';

  @override
  String get takeSelfieLabel => 'Take selfie';

  @override
  String get aboutMeTitle => 'About you';

  @override
  String get aboutMeSubtitle =>
      'Optional. Write briefly — candidates will read this.';

  @override
  String get aboutMeHint =>
      'Write 2–3 sentences about yourself, your work, and family values...';

  @override
  String aboutMeCounter(int count) {
    return '$count / 300 characters';
  }

  @override
  String get mainPhotoSelectionHint => 'Select your main photo';

  @override
  String get mainPhotoSubtitle =>
      'This photo appears first on your profile and is compared with your selfie.';

  @override
  String get mainPhotoBadge => 'MAIN';

  @override
  String get faceRetryHint => 'The selfie did not match. Please try again.';

  @override
  String get faceCameraError => 'The camera could not be started.';

  @override
  String get onboardingSuccessTitle => 'Your profile is ready!';

  @override
  String get onboardingSuccessSubtitle =>
      'Everything is saved. You can now see candidates who may be a good fit.';

  @override
  String get pledgeConfirmationTitle => 'Confirm your intention';

  @override
  String get pledgeConfirmationSubtitle =>
      'This step is required. After confirming, a Serious Intent badge will appear on your profile.';

  @override
  String get pledgeConfirmationPointOne =>
      'My information is accurate and belongs to me.';

  @override
  String get pledgeConfirmationPointTwo =>
      'My intention is serious — I came here to build a family.';

  @override
  String get pledgeConfirmationPointThree =>
      'I will treat conversation partners with respect.';

  @override
  String get pledgeConfirmationButton => 'Confirm pledge';

  @override
  String get privacyPolicyAgreementSuffix => ' to learn more';

  @override
  String get aiTestBadge => 'AI COMPATIBILITY TEST';

  @override
  String get aiTestTitle => 'Ready to answer 30 questions?';

  @override
  String get aiTestDescription =>
      'We will calculate your compatibility with each candidate from your answers. It takes about 8 minutes.';

  @override
  String get aiTestPointOne => 'AI analysis is ready in 8 minutes';

  @override
  String get aiTestPointTwo => 'Compatible matches are selected automatically';

  @override
  String get aiTestPointThree => 'Your answers are not shown to anyone';

  @override
  String get startAiTest => 'Yes, start the test';

  @override
  String get viewCandidatesLater => 'Later — show me candidates first';

  @override
  String get appTitle => 'Digital Matchmaker';

  @override
  String get loading => 'Loading...';

  @override
  String get splashSubtitle => 'Take it slow, with family';

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginHeadline => 'Take it slow,\nwith family';

  @override
  String get loginSubtitle => 'Let us start with your phone number';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneError => 'Enter a valid Uzbekistan phone number.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get orLabel => 'or';

  @override
  String get loginNote =>
      'Your number stays private. Every profile is reviewed manually, so only serious marriage-minded people stay here.';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpSentTo(String phone) {
    return 'We sent a 4-digit code to $phone';
  }

  @override
  String get otpResend => 'Did not receive it? Resend in 00:48';

  @override
  String get confirmLabel => 'Confirm';

  @override
  String get candidateTypeTitle => 'Who are you looking for?';

  @override
  String get candidateTypeSubtitle =>
      'This choice determines your questionnaire. We will not ask your gender again.';

  @override
  String get groomCandidateTitle => 'Groom candidate';

  @override
  String get groomCandidateSubtitle => 'I am a man, looking for myself';

  @override
  String get brideCandidateTitle => 'Bride candidate';

  @override
  String get brideCandidateSubtitle => 'I am a woman, looking for myself';

  @override
  String get representativeCandidateTitle => 'Representative';

  @override
  String get representativeCandidateSubtitle =>
      'I am filling out an application for someone close to me';

  @override
  String get pledgeTitle => 'For trust between us';

  @override
  String get pledgePointOne =>
      'I will use this app only with the intention of marriage.';

  @override
  String get pledgePointTwo =>
      'My information is accurate, and the photos are mine.';

  @override
  String get pledgePointThree =>
      'I will be respectful in conversations and agree to AI moderation.';

  @override
  String get pledgeAgreement =>
      'I agree. Show the Serious Intent badge on my profile.';

  @override
  String get pledgeStart => 'Start questionnaire';

  @override
  String onboardingProgress(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get birthDateTitle => 'Your birth year';

  @override
  String get birthDateHint => 'Users under 18 cannot register.';

  @override
  String get birthDateSubtitle =>
      'Your age is visible to candidates, not the exact date.';

  @override
  String get identityTitle => 'Your name and surname';

  @override
  String get identitySubtitle =>
      'Write it as it appears in your passport. Candidates will see this name.';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get patronymicLabel => 'Father\'s name (optional)';

  @override
  String get educationTitle => 'What is your education?';

  @override
  String get heightTitle => 'Your height';

  @override
  String get heightWeightTitle => 'Your height and weight';

  @override
  String get heightLabel => 'Height (cm)';

  @override
  String get heightInputLabel => 'Your height';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightLabel => 'Weight (kg)';

  @override
  String get weightInputLabel => 'Your weight';

  @override
  String get weightUnit => 'kg';

  @override
  String get decreaseHeightLabel => 'Decrease height';

  @override
  String get increaseHeightLabel => 'Increase height';

  @override
  String get decreaseWeightLabel => 'Decrease weight';

  @override
  String get increaseWeightLabel => 'Increase weight';

  @override
  String get locationTitle => 'Where do you live?';

  @override
  String get regionLabel => 'Region';

  @override
  String get districtLabel => 'District';

  @override
  String get regionSheetTitle => 'Select a region';

  @override
  String regionSheetCount(Object count) {
    return '$count regions';
  }

  @override
  String get districtSheetTitle => 'Select a district / city';

  @override
  String districtSheetSubtitle(Object count, Object region) {
    return '$region · $count districts';
  }

  @override
  String get locationSearchPlaceholder => 'Search by district name';

  @override
  String get selectLabel => 'Select';

  @override
  String get unselectedValue => 'Not selected';

  @override
  String get selectRegionFirstValue => 'Select a region first';

  @override
  String get healthStatusTitle => 'Your health status';

  @override
  String get healthStatusSubtitle =>
      'This information is used only for compatibility matching.';

  @override
  String get healthHealthyLabel => 'Healthy';

  @override
  String get healthDisabilityLabel => 'Has a disability';

  @override
  String get healthDisabilityHint =>
      'You can briefly explain it in the next step';

  @override
  String get maritalStatusTitle => 'Your marital status';

  @override
  String get maritalStatusDivorcedHint =>
      'When you select «Divorced», the number of children is required.';

  @override
  String get maritalStatusFirstMarriageDetail => 'Never married';

  @override
  String get maritalStatusDivorcedDetail =>
      'The number of children will be requested';

  @override
  String get childrenCountLabel => 'Number of your children';

  @override
  String get decreaseChildrenLabel => 'Decrease children count';

  @override
  String get increaseChildrenLabel => 'Increase children count';

  @override
  String get childrenNotLivingTitle => 'Children do not live with me';

  @override
  String get childrenNotLivingDetail =>
      'The profile will show that you have children without details';

  @override
  String get photoTitle => 'Add your photos';

  @override
  String get photoHint => 'Up to 5 photos. Only people you allow can see them.';

  @override
  String get photoPrivacyHint =>
      'At least 1 photo is required. Your face must be clearly visible.';

  @override
  String get photoSlotAddLabel => 'photo';

  @override
  String photoSlotFilledLabel(int order) {
    return 'photo $order ✓';
  }

  @override
  String get addPhoto => 'Add photo';

  @override
  String get setMainPhoto => 'Set as main';

  @override
  String get removePhoto => 'Remove';

  @override
  String get voiceTitle => 'Introduce yourself by voice';

  @override
  String get voiceHint => 'Record up to 30 seconds in AAC/M4A format.';

  @override
  String get voiceShortHint =>
      '10–15 seconds is enough. Voice says more about a person than a photo.';

  @override
  String get startRecording => 'Start recording';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get playRecording => 'Play recording';

  @override
  String get voiceSubtitle =>
      'Optional. 10–15 seconds is enough — voice says more about a person.';

  @override
  String get startRecordingHint => 'Tap to start recording';

  @override
  String get recordedVoiceHint =>
      'Listen to it. Record again or delete it if you do not like it — voice is optional.';

  @override
  String get reRecordVoice => 'Record again';

  @override
  String get deleteVoice => 'Delete';

  @override
  String get locationPermissionTitle => 'Your location';

  @override
  String get locationPermissionSubtitle =>
      'Location permission is required to show nearby candidates first. Your exact address will not be visible to anyone.';

  @override
  String get enableLocation => 'Enable location';

  @override
  String get skipLabel => 'Skip';

  @override
  String get faceTitle => 'Verify your face';

  @override
  String get faceHint =>
      'Take a clear selfie with your face straight and eyes open.';

  @override
  String get verifyFace => 'Verify face';

  @override
  String get finishOnboarding => 'Finish and open profile';

  @override
  String get representativeFlowMessage =>
      'The representative flow has its own questionnaire and will be available separately.';

  @override
  String get representativeIntroTitle => 'You entered as a representative';

  @override
  String get representativeIntroSubtitle =>
      'A representative is a close relative of the candidate. You complete the profile and review incoming proposals on their behalf.';

  @override
  String get representativeConsentRequiredTitle =>
      'The candidate’s consent is required';

  @override
  String get representativeConsentRequiredBody =>
      'An SMS is sent after the profile is completed. The profile remains hidden until the candidate confirms.';

  @override
  String get representativeIntroFootnote =>
      'We will first ask about you, then about the candidate.';

  @override
  String get startLabel => 'Start';

  @override
  String get representativeSelfSection => 'PART 1 · ABOUT YOU';

  @override
  String get representativeSelfTitle => 'About you';

  @override
  String get representativeSelfSubtitle =>
      'The candidate will see this name in the consent request.';

  @override
  String get representativeRelationTitle =>
      'How are you related to the candidate?';

  @override
  String get representativeCandidateSection => 'PART 2 · ABOUT THE CANDIDATE';

  @override
  String get representativeCandidateTypeTitle => 'Who is the candidate?';

  @override
  String get representativeCandidateTypeSubtitle =>
      'All following questions are about the candidate, not about you.';

  @override
  String get representativeBrideTitle => 'Bride';

  @override
  String get representativeBrideSubtitle => 'Female candidate';

  @override
  String get representativeGroomTitle => 'Groom';

  @override
  String get representativeGroomSubtitle => 'Male candidate';

  @override
  String get representativeCandidateIdentityTitle =>
      'Candidate’s first and last name';

  @override
  String get representativeCandidateIdentitySubtitle =>
      'The candidate will confirm this information and can correct it later.';

  @override
  String get representativeBirthDateTitle => 'Candidate’s birth year';

  @override
  String get representativeEducationTitle => 'Candidate’s education';

  @override
  String get representativeHeightWeightTitle => 'Candidate’s height and weight';

  @override
  String get representativeHeightInputLabel => 'Candidate’s height';

  @override
  String get representativeWeightInputLabel => 'Candidate’s weight';

  @override
  String get representativeLocationTitle => 'Where does the candidate live?';

  @override
  String get representativeHealthStatusTitle => 'Candidate’s health status';

  @override
  String get representativeMaritalStatusTitle => 'Candidate’s marital status';

  @override
  String get representativeChildrenCountLabel =>
      'Candidate’s number of children';

  @override
  String get representativeChildrenNotLivingTitle =>
      'The children do not live with the candidate';

  @override
  String get representativePhotoTitle => 'Candidate’s photos';

  @override
  String get representativePhotoHint =>
      'Up to 5 photos. Only people approved by the candidate can see them.';

  @override
  String get representativeMainPhotoSubtitle =>
      'This photo appears first on the candidate’s profile.';

  @override
  String get representativeAboutTitle => 'About the candidate';

  @override
  String get representativeAboutSubtitle =>
      'Optional. Answer about the candidate, not about yourself.';

  @override
  String get representativeAboutHint =>
      'Write 2–3 sentences about the candidate’s work, interests, and family values...';

  @override
  String get representativeVoiceTitle => 'Candidate’s voice introduction';

  @override
  String get representativeVoiceSubtitle =>
      'Optional. The candidate can record it again later.';

  @override
  String get representativeLocationPermissionTitle => 'Candidate’s location';

  @override
  String get representativeLocationPermissionSubtitle =>
      'Optional. The exact address is never shown.';

  @override
  String get representativeConsentSection => 'PART 3 · CONSENT';

  @override
  String get representativeContactTitle => 'Candidate’s phone number';

  @override
  String get representativeContactSubtitle =>
      'A consent request will be sent here. The profile remains hidden until confirmed.';

  @override
  String get representativeContactLabel => 'Phone number / email';

  @override
  String get representativeContactWarningTitle =>
      'This must belong to the candidate';

  @override
  String get representativeContactWarningBody =>
      'Using your own contact invalidates consent and may block the profile.';

  @override
  String get representativeSendConsent => 'Send consent request';

  @override
  String get representativeCandidateNoApp =>
      'The candidate does not use the app';

  @override
  String get representativeConsentSentTitle => 'Request sent';

  @override
  String representativeConsentSentSubtitle(String firstName) {
    return 'Waiting for $firstName to confirm. The profile stays hidden until then.';
  }

  @override
  String get representativeSmsSentTitle => 'SMS sent to the candidate';

  @override
  String representativeSmsSentBody(String representativeName) {
    return '$representativeName completed a profile on your behalf. Do you consent?';
  }

  @override
  String get representativeConsentRevocation =>
      'The candidate can withdraw consent at any time and the profile will be hidden immediately.';

  @override
  String get understoodLabel => 'Understood';

  @override
  String get resendRequestLabel => 'Send again';

  @override
  String get representativePledgeTitle => 'Confirm your responsibility';

  @override
  String get representativePledgeSubtitle =>
      'This step is required because you are entering information for another person.';

  @override
  String get representativePledgePointOne =>
      'The candidate’s information is accurate and entered with their consent.';

  @override
  String get representativePledgePointTwo =>
      'I will not interfere with the candidate’s private conversations.';

  @override
  String get representativePledgePointThree =>
      'I will review proposals in the candidate’s best interest.';

  @override
  String get representativeReadyTitle => 'Your profile is ready!';

  @override
  String get representativeReadySubtitle =>
      'Everything is saved. You can now view suitable candidates.';

  @override
  String get representativeSetCriteria => 'Set search criteria';

  @override
  String get laterLabel => 'Later';

  @override
  String get candidateConsentEyebrow => 'ON THE CANDIDATE’S PHONE';

  @override
  String get candidateConsentTitle => 'A profile was completed for you';

  @override
  String candidateConsentBody(String representativeName, String relation) {
    return '$representativeName ($relation) completed a profile for you. It remains hidden without your consent.';
  }

  @override
  String get candidateConsentApproveTitle => 'If you consent';

  @override
  String get candidateConsentApproveBody =>
      'The profile becomes active and can receive proposals. You can edit it later.';

  @override
  String get candidateConsentRejectHint =>
      'If you reject it, the profile is deleted and the representative is notified.';

  @override
  String get agreeLabel => 'I agree';

  @override
  String get rejectLabel => 'Reject';

  @override
  String get backLabel => 'Back';

  @override
  String get temporaryOtpHint => 'Development adapter: use 1234';

  @override
  String get pinCreateTitle => 'Create a short code';

  @override
  String get pinUnlockTitle => 'Enter your PIN';

  @override
  String get pinHintCreate =>
      'Keep your account private. You will enter this code every time you sign in.';

  @override
  String get pinHintUnlock => 'Enter the PIN you created for this device.';

  @override
  String get unlockLabel => 'Unlock';

  @override
  String get signInAsDemo => 'Sign in as demo user';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeMessage => 'Foundation is ready for the next feature.';

  @override
  String get logout => 'Log out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountMessage =>
      'This will permanently delete your account and associated profile data. This action cannot be undone.';

  @override
  String get deleteAccountCancel => 'Cancel';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get telegramWaiting =>
      'Confirm your phone number in Telegram, then return here.';

  @override
  String get candidatesTabLabel => 'Candidates';

  @override
  String get messagesTabLabel => 'Messages';

  @override
  String get servicesTabLabel => 'Services';

  @override
  String get savedTabLabel => 'Saved';

  @override
  String get profileTabLabel => 'Profile';

  @override
  String get candidatesPlaceholder => 'Candidates page for now.';

  @override
  String get messagesPlaceholder => 'Messages page for now.';

  @override
  String get servicesPlaceholder => 'Services page for now.';

  @override
  String get savedPlaceholder => 'Saved page for now.';

  @override
  String get profilePlaceholder => 'Profile page for now.';

  @override
  String get notificationsActionLabel => 'Notifications';

  @override
  String get notificationsEmpty => 'There are no notifications yet';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get candidatesFilterMatches => 'Matches';

  @override
  String get candidatesFilterRecommended => 'Recommendations';

  @override
  String get candidatesFilterNearby => 'Nearby';

  @override
  String get privatePhotoLabel => 'Private photo';

  @override
  String get matchLockedLabel => 'match locked';

  @override
  String get genericError => 'Something went wrong.';

  @override
  String get savedEmptyState => 'No saved profiles yet.';

  @override
  String get candidateDetailRequestPhotoPermission =>
      'Request permission to view the photo';

  @override
  String get candidateDetailOptionsSubtitle => 'What would you like to do?';

  @override
  String get candidateDetailSaveSubtitle => 'You can find it later in Saved';

  @override
  String get candidateDetailSaveToSaved => 'Add to Saved';

  @override
  String get candidateDetailShare => 'Share profile';

  @override
  String get candidateDetailShareSubtitle =>
      'Send it to your representative or family';

  @override
  String get candidateDetailPhotoPermissionSubtitle =>
      'The request goes to the candidate and representative';

  @override
  String get candidateDetailReport => 'Report profile';

  @override
  String get candidateDetailReportSubtitle =>
      'A moderator will review it within 24 hours';

  @override
  String get candidateDetailBlock => 'Block profile';

  @override
  String get candidateDetailBlockSubtitle => 'They will no longer see you';

  @override
  String get candidateDetailCompatibilityTitle => 'Overall compatibility';

  @override
  String candidateDetailVoiceIntro(String duration) {
    return 'Voice introduction · $duration';
  }

  @override
  String get candidateDetailVoiceDuration => '12 sec';

  @override
  String get candidateDetailSendProposal => 'Send matchmaking proposal';

  @override
  String get candidateDetailSave => 'Save';

  @override
  String get candidateDetailUnsave => 'Remove from saved';

  @override
  String get candidateDetailNoPhoto => 'No profile photo';

  @override
  String get candidateDetailLastActivity => 'Last active: recently';

  @override
  String get candidateDetailCompatibilityUnavailableTitle =>
      'Compatibility not calculated';

  @override
  String get candidateDetailCompatibilityUnavailableDescription =>
      'The candidate has not yet completed the 30-question survey, so a compatibility percentage cannot be shown. The information below comes from the candidate profile.';

  @override
  String get candidateDetailBasicInformation => 'Basic information';

  @override
  String get candidateDetailBirthYear => 'Birth year';

  @override
  String candidateDetailBirthYearWithAge(int birthYear, int age) {
    return '$birthYear · $age years old';
  }

  @override
  String get candidateDetailCity => 'City';

  @override
  String get candidateDetailMaritalStatus => 'Marital status';

  @override
  String get candidateDetailChildren => 'Children';

  @override
  String get candidateDetailNoChildren => 'No';

  @override
  String get candidateDetailHasChildren => 'Yes';

  @override
  String candidateDetailChildrenCount(int count) {
    return '$count';
  }

  @override
  String get candidateDetailEducationAndWork => 'Education and work';

  @override
  String get candidateDetailEducation => 'Education';

  @override
  String get candidateDetailAdditionalInformation => 'Additional information';

  @override
  String get candidateDetailHealthStatus => 'Health status';

  @override
  String get candidateDetailIncompleteProfileTitle => 'Profile is incomplete';

  @override
  String get candidateDetailIncompleteProfileDescription =>
      'The candidate has not completed some information yet. When a matchmaking proposal is sent, they will be reminded to finish the profile.';

  @override
  String get candidateDetailAbout => 'About the candidate';

  @override
  String get candidateRequestPending => 'In progress...';

  @override
  String get candidateRequestRetry => 'Send request again';

  @override
  String candidateRequestRetryAt(Object date) {
    return 'Send request again: $date';
  }

  @override
  String get candidateRequestChat => 'Start a conversation';

  @override
  String get candidateRequestForwarded => 'Sent to representative';

  @override
  String get photoRequestTitle => 'Photo access request';

  @override
  String get photoRequestDescription =>
      'The request is sent to the candidate and their representative. The decision is theirs.';

  @override
  String get photoRequestMessageHint => 'Message (optional)';

  @override
  String get photoRequestDurationLabel => 'Request duration';

  @override
  String get photoRequestDurationValue => '7 days';

  @override
  String get photoRequestRejectLabel => 'If rejected';

  @override
  String get photoRequestRejectValue => 'request again after 7 days';

  @override
  String get photoRequestPrivacyNote =>
      'If opened, the photo is visible only to you and screenshots are blocked.';

  @override
  String get photoRequestSubmit => 'Send request';

  @override
  String get candidateProposalSentTitle => 'Proposal sent';

  @override
  String candidateProposalSentDescription(Object name) {
    return '$name and their representative will review your proposal. We will notify you when they reply.';
  }

  @override
  String get candidateProposalSentTimelineSent => 'Proposal sent';

  @override
  String candidateProposalSentTimelineReview(Object name) {
    return '$name will review it';
  }

  @override
  String get candidateProposalSentTimelineChat =>
      'A chat will open when they reply';

  @override
  String get candidateProposalSentQuotaLabel => 'Weekly proposals';

  @override
  String get candidateProposalSentQuotaValue => '2 / 3';

  @override
  String candidateProposalSentNote(Object remaining) {
    return 'Do not be discouraged if there is no reply — it is a matter of choice. $remaining more proposal(s) left.';
  }

  @override
  String get candidateProposalSentReturn => 'Back to candidates';

  @override
  String get candidatePhotoPermissionSentTitle => 'Photo access requested';

  @override
  String candidatePhotoPermissionSentDescription(Object name) {
    return 'A request to view the photo was sent to $name and their representative. We will notify you when they reply.';
  }

  @override
  String get candidatePhotoPermissionSentReturn => 'Back to profile';

  @override
  String get surveyPromptTitle => 'Match percentage locked';

  @override
  String get surveyPromptMessage =>
      'Answer 30 questions — AI will analyze your answers and automatically calculate your compatibility with each candidate.';

  @override
  String get surveyPromptButton => 'Start questionnaire';

  @override
  String get mockCandidateMohira => 'Mohira R., 23';

  @override
  String get mockCandidateZilola => 'Zilola K., 25';

  @override
  String get mockCandidateNilufar => 'Nilufar A., 22';

  @override
  String get mockCandidateDilnoza => 'Dilnoza S., 27';

  @override
  String get mockCityTashkent => 'Tashkent';

  @override
  String get mockCitySamarkand => 'Samarkand';

  @override
  String get mockCityFergana => 'Fergana';

  @override
  String get mockCityBukhara => 'Bukhara';

  @override
  String get messagesSegmentChats => 'Chats';

  @override
  String get messagesSegmentRequests => 'Requests';

  @override
  String get mockMessageMohiraName => 'Mohira R.';

  @override
  String get mockMessageZilolaName => 'Zilola K.';

  @override
  String get mockMessageNilufarName => 'Nilufar A.';

  @override
  String get mockMessageDilnozaName => 'Dilnoza S.';

  @override
  String get mockMessageMohiraPreview =>
      'If you have time, let us get acquainted.';

  @override
  String get mockMessageZilolaPreview => 'Your invitation was viewed';

  @override
  String get mockMessageNilufarPreview => 'Chat expired';

  @override
  String get mockMessageDilnozaPreview => 'Waiting for a response';

  @override
  String get messageTimeYesterday => 'Yesterday';

  @override
  String get messageTimeMonday => 'Mon';

  @override
  String get messageTimeTuesday => 'Tue';

  @override
  String get savedFilterAll => 'All';

  @override
  String get savedFilterInvited => 'Invitation sent';

  @override
  String get savedFilterWaiting => 'Waiting for reply';

  @override
  String savedLimitLabel(int savedCount, int limit) {
    return '$savedCount / $limit saved';
  }

  @override
  String get savedPremiumCta => 'Premium — unlimited';

  @override
  String savedUpsellTitle(int remaining) {
    return '$remaining spots left';
  }

  @override
  String get savedUpsellMessage =>
      'The free plan stores up to 10 profiles. Premium has no limit.';

  @override
  String get questionnaireOptionalBadge => 'Optional step';

  @override
  String questionnaireIntroTitle(int count, int minutes) {
    return '$count questions — $minutes minutes';
  }

  @override
  String get questionnaireIntroDescription =>
      'We analyze your answers and show your compatibility percentage with each candidate. You can also complete it later.';

  @override
  String questionnaireQuestionCount(int count) {
    return '$count questions';
  }

  @override
  String get questionnaireWithoutTitle =>
      'What happens without the questionnaire?';

  @override
  String get questionnaireWithoutBody =>
      'Your profile and candidates remain available, but AI will not calculate compatibility percentages or section analysis.';

  @override
  String get questionnaireStart => 'Yes, start questionnaire';

  @override
  String get questionnaireLater => 'Complete later';

  @override
  String get questionnaireEmpty => 'No questions are available yet.';

  @override
  String questionnaireProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String get questionnaireNext => 'Next question';

  @override
  String get questionnaireSubmit => 'Submit answers';

  @override
  String get questionnaireAnalysisTitle => 'Analyzing your answers';

  @override
  String get questionnaireAnalysisBody =>
      'AI builds your values, finance, and character profile and selects suitable candidates.';

  @override
  String get questionnaireResultTitle => 'Your profile is ready';

  @override
  String get questionnaireHonestyTitle => 'Sincerity index · high';

  @override
  String get questionnaireHonestyBody =>
      'Your verification answers are consistent. The profile was marked as trustworthy.';

  @override
  String get questionnaireSeriousBadge => '“Serious intentions” badge awarded';

  @override
  String get questionnaireShowCandidates => 'View matching candidates';

  @override
  String get questionnaireTraitTraditional => 'traditional';

  @override
  String get questionnaireTraitBalanced => 'balanced';

  @override
  String get candidatesViewGrid => 'Grid view';

  @override
  String get candidatesViewMap => 'Map view';

  @override
  String get nearbyPermissionTitle => 'Candidates near you';

  @override
  String get nearbyPermissionDescription =>
      'Your location is used as an approximate zone, never as an exact point.';

  @override
  String get nearbyPermissionOpenSettings => 'Open settings';

  @override
  String get nearbyPermissionEnableService => 'Enable location';

  @override
  String get nearbyPermissionAllow => 'Allow location access';

  @override
  String get nearbyPermissionNotNow => 'Not now';

  @override
  String get nearbyPermissionFootnote =>
      'If you choose “Not now”, Matches and Recommendations will continue to work as before.';

  @override
  String get nearbyPermissionRuleHidden =>
      'Your exact address is never shown to anyone';

  @override
  String get nearbyPermissionRuleZone =>
      'Others see you within an approximately 2 km zone';

  @override
  String get nearbyPermissionRuleSettings =>
      'You can turn this off in Settings at any time';

  @override
  String get nearbyUnknownZone => 'Nearby zone';

  @override
  String nearbyCandidateCount(int count) {
    return '$count candidates';
  }

  @override
  String nearbyZoneDistance(String zone, String distance) {
    return '$zone · ~$distance km';
  }

  @override
  String get nearbyYou => 'You';

  @override
  String nearbyAroundCount(int count) {
    return '$count candidates around you';
  }

  @override
  String get nearbyShowAll => 'View all';

  @override
  String get openStreetMapAttribution => '© OpenStreetMap contributors';

  @override
  String nearbyWithinRadius(int radius) {
    return 'Within $radius km';
  }

  @override
  String get nearbyRecenter => 'Return to my location';

  @override
  String get nearbySettingsTitle => 'Radius and visibility';

  @override
  String get nearbySearchRadiusLabel => 'Search radius';

  @override
  String nearbyRadiusOption(int radius) {
    return '$radius km';
  }

  @override
  String get nearbyEntireRegion => 'Entire region';

  @override
  String get nearbyEntireRegionUnavailable =>
      'Region-wide search is not available yet';

  @override
  String get nearbyRadiusHint =>
      'The larger the radius, the lower the compatibility percentage may be.';

  @override
  String get nearbyVisibilityTitle => 'Show me in the Nearby list';

  @override
  String get nearbyVisibilitySubtitle =>
      'If you turn this off, you will not see anyone either';

  @override
  String get nearbyAudienceTitle => 'Who can see me in Nearby';

  @override
  String get nearbyAudienceAll => 'All candidates';

  @override
  String get nearbyAudienceHighMatch => 'Only compatibility above 70%';

  @override
  String get nearbyAudienceRecommended => 'recommended';

  @override
  String get nearbyAudienceRepresented =>
      'Only candidates with a representative';

  @override
  String get nearbyPrivacyZoneNote =>
      'The zone center shifts randomly once a day, so your home cannot be calculated.';

  @override
  String get nearbySettingsSave => 'Save';

  @override
  String nearbyEmptyTitle(int radius) {
    return 'No candidates within $radius km yet';
  }

  @override
  String get nearbyEmptyDescription =>
      'Increase the radius or relax the criteria a little.';

  @override
  String nearbyExpandRadius(int radius) {
    return 'Increase radius to $radius km';
  }

  @override
  String get nearbyChangeCriteria => 'Change criteria';

  @override
  String get nearbyNotifyTitle => 'Notify me when a new candidate appears';

  @override
  String get nearbyNotifySubtitle => 'At most once a day';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileSettings => 'Profile settings';

  @override
  String profileIdentifier(String code) {
    return 'User ID: $code';
  }

  @override
  String get profilePreview => 'View as others';

  @override
  String get profileCopyIdentifier => 'Copy user ID';

  @override
  String get profileCompleteTitle => 'Complete your profile';

  @override
  String get profileCompleteSubtitle => 'To find a more accurate match';

  @override
  String get profileMyPhotos => 'MY PHOTOS';

  @override
  String get profileMainPhoto => 'MAIN';

  @override
  String get profileAddPhoto => 'Add photo';

  @override
  String profilePhotoSemantics(int index) {
    return 'Profile photo $index';
  }

  @override
  String get profileAboutSection => 'ABOUT YOU';

  @override
  String get profileNotFilled => 'Not filled in yet';

  @override
  String get profileAdd => 'Add';

  @override
  String get profileEditShort => 'Edit';

  @override
  String get profilePhotoVerification => 'Photo verification';

  @override
  String get profilePhotoVerificationSubtitle =>
      'Your main photo is compared with a camera selfie';

  @override
  String get profileServices => 'Services';

  @override
  String get profileServicesSubtitle =>
      'Psychologist, family meeting, verification and Premium';

  @override
  String get profileIdentifierCopied => 'User ID copied';

  @override
  String get profileActionComingSoon =>
      'This section will be connected in the next profile stage';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsBack => 'Back';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsEditProfile => 'Edit profile';

  @override
  String get settingsPhotoPrivacy => 'Photo privacy';

  @override
  String get settingsPhotoPrivacyAll => 'Visible to everyone';

  @override
  String get settingsBlockedUsers => 'Blocked users';

  @override
  String get settingsRecoveryQuestion => 'Account recovery question';

  @override
  String get settingsPrivacyChatSection => 'Privacy and chat';

  @override
  String get settingsPrivacyVeil => 'Privacy and veil mode';

  @override
  String get settingsChatLimits => 'Chat limits';

  @override
  String get settingsChatLimitValue => '72 hours';

  @override
  String get settingsParentLink => 'Connect a parent';

  @override
  String get settingsNotificationAppearanceSection =>
      'Notifications and appearance';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Get notified about new likes, matches and messages';

  @override
  String get settingsNotificationTypes => 'Notification types';

  @override
  String get settingsDocumentsSection => 'Documents';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsHelpInfoSection => 'Help and information';

  @override
  String get settingsServices => 'Services';

  @override
  String get settingsHelpCenter => 'Help center';

  @override
  String get settingsShareApp => 'Share the app';

  @override
  String get settingsLogout => 'Log out of account';

  @override
  String get settingsActionComingSoon =>
      'This setting will be connected in the next stage';

  @override
  String failureMessage(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'networkTimeout': 'Connection timed out.',
      'noInternet': 'No internet connection.',
      'unauthorized': 'Session expired.',
      'cancelled': '',
      'forbidden': 'Access denied.',
      'notFound': 'Data was not found.',
      'validation': 'Please check your input.',
      'configuration': 'Google sign-in is not configured for this build.',
      'unsupported': 'This sign-in method is not available yet.',
      'server': 'A server error occurred.',
      'unknown': 'Something went wrong.',
      'other': 'Something went wrong.',
    });
    return '$_temp0';
  }
}
