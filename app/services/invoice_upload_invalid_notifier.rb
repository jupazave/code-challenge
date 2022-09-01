# frozen_string_literal: true

class InvoiceUploadInvalidNotifier
  method_object :user, :count

  def call
    # This class should send an email, raise an error in sentry (or bugsnag)
    # or a message to salck with the invalid invoices
  end
end
