defmodule Authentication.Guardian do
  use Guardian, otp_app: :authentication

  def subject_for_token(nil, _), do: {:error, :reason_for_error}
  def subject_for_token(user_id, _claims), do: {:ok, user_id}

  def resource_from_claims(nil), do: {:error, :reason_for_error}
  def resource_from_claims(claims), do: {:ok, claims["sub"]}
end
