defmodule Managexr.AuthTest do
  use Phoenix.ConnTest
  use Managexr.DataCase

  alias Managexr.Auth
  alias Managexr.Auth.Authenticator

  alias Managexr.Accounts

  describe "auth" do
    alias Managexr.Auth.AuthToken

    @valid_attrs %{"email" => "test_email@example.com", "password" => "test_password"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    def token_fixture() do
      user_fixture()

      Auth.sign_in(@valid_attrs)
    end

    def conn_fixture(token) do
      build_conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")
    end
  end

  test "get_token/1 returns a generated token" do
    token = token_fixture()
    assert token != nil
  end

  test "sign_in/1 sign user in and return token" do
    user_fixture()
    assert {:ok, %Managexr.Auth.AuthToken{} = token} = Auth.sign_in(@valid_attrs)
  end

  test "sign_in/1 fail to sign in user with invalid credentials" do
    assert {:error, :invalid_credentials} == Auth.sign_in(@valid_attrs)
  end

  test "sign_out/1 sign user out" do
    {:ok, auth} = token_fixture()
    conn = conn_fixture(auth.token)

    assert {:ok, _} = Auth.sign_out(conn)
  end

  test "sign_out/1 fail to sign user out" do
    token = "test_token"
    conn = conn_fixture(token)

    assert {:error, :invalid_token} == Auth.sign_out(conn)
  end
end
