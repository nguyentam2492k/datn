enum RequestType {
  certificate('certificate'),
  transcript('transcript'),
  pauseExam('pause-exam'),
  reviewExam('review-exam'),
  pauseTuition('pause-tuition'),
  borrowFile('borrow-file'),
  socialAssistance('social-assistance'),
  bankLoan('bank-loan'),
  studentCard('student-card'),
  tempCertificate('temp-certificate'),
  timeLimitedAbsence('time-limited-absence'),
  continueStudy('continue-study'),
  stopStudy('stop-study'),
  goingAbroad('going-abroad'),
  notFinishedSubject('not-finished-subject'),
  tuitionExemption('tuition-exemption'),
  busCard('bus-card'),
  houseRental('house-rental'),
  pointConfirm('point-confirm'),
  introduceStudent('introduce-student');

  final String value;

  const RequestType(this.value);
}