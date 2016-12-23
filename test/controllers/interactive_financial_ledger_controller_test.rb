require 'test_helper'

class InteractiveFinancialLedgerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get interactive_financial_ledger_index_url
    assert_response :success
  end

end
