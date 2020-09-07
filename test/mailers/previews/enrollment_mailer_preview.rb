# Preview all emails at http://localhost:3000/rails/mailers/enrollment_mailer
class EnrollmentMailerPreview < ActionMailer::Preview

  def student_enrollment
    EnrollmentMailer.student_enrollment(Enrollment.last).deliver_now
    # @enrollment = Enrollment.first
  end

  def teacher_enrollment
    EnrollmentMailer.teacher_enrollment(Enrollment.last).deliver_now
    # @enrollment = Enrollment.first
  end

end
