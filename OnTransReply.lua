function OnInit()
	class 		= "QJSIM"					-- ����� �����: ����� -- QJSIM
	tiker 		= "SBER"					-- �����: ����
	account 	= "NL0011100043"			-- �������� ����
	id_transact = 0			  				-- id ������� ���� ����������
	progname	= "sndTrnsctn_v1"			-- �������� �������
	commentid	= "sndTr_v1/"				-- ����������� � ������
	title1 		= "OnTransReply / "
end
 
function OnTransReply(trn)
	message(string.rep("-",25))
	message(title1.." trn_id="..tostring(trn.trans_id).." / status="..trn.status.." / order_num="..trn.order_num)
	message(title1.." price="..trn.price.." / quantity="..trn.quantity.." / brokerref="..trn.brokerref)
	message(title1.." result_msg="..trn.result_msg)
	time2 = os.clock()
	message(title1.." ����� ������� "..(time2-time1).." ���.")
end



function newtransaction(operation, quant, price)

id_transact = id_transact + 1

mytransaction  = 
	{
	["TRANS_ID"]			= tostring(id_transact),-- id ����������
	["ACTION"]				= "NEW_ORDER", 			-- ��� ������: ���������� ����� ������
	["CLASSCODE"]			= class ,				-- ����� ������
	["SECCODE"]				= tiker,				-- �����
	["QUANTITY"]			= tostring(quant), 		-- �����
	["PRICE"]				= tostring(price),		-- ����
	["ACCOUNT"]				= account,				-- �������� ����
	["CLIENT_CODE"]			= commentid..id_transact, -- ����������� ��� ���������, �� 12 ��������
	["EXECUTION_CONDITION"] = "PUT_IN_QUEUE"		-- ������� ����������:  ��������� � ������� 
	}

	if operation == 1 then
		mytransaction["OPERATION"] = "B"
	else
		mytransaction["OPERATION"] = "S"
	end

	error_transaction = sendTransaction(mytransaction)

	if error_transaction ~= "" then
		message(progname.." : ������ ����������� ������ :"..error_transaction, 3)
	else
		message(progname.." : ������ ���������� �������. id ����������="..id_transact)
	end


end

function main()
	message(string.rep("-",20)) -- �����������
	quant = 1 					-- ����� �������
	operation = 1 				-- ����������� ������
	time1 = os.clock()			-- �������� ������
	price_order  = tonumber(getParamEx(class, tiker, "LAST").param_value) - 0.3
	newtransaction(operation, quant, price_order)
	message("����� ����������� ������: "..tostring(os.date('%H:%M:%S')))
	sleep(300)
	do_it = true
		while do_it do
			sleep(1000)
		end	
end