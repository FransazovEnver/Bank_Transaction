CREATE OR REPLACE PROCEDURE sp_transfer_money(
	IN sender_id int, 				--The sender id
	IN receiver_id int,				--The receiver id
	IN transfer_amount int,			--Transfer amount(money to transfer)
	OUT status varchar(50)			--Status for fail or succeed transfer
)

AS 
$$
	DECLARE
		sender_amount int;
		receiver_amount int;
		temp_val int;
	BEGIN
		SELECT bgn FROM bank WHERE id = sender_id INTO sender_amount;
		IF sender_amount < transfer_amount THEN
			status := 'The sender does not have enough money';
			RETURN;
		END IF;
		SELECT bgn FROM bank WHERE id = receiver_id INTO receiver_amount;

		UPDATE bank SET bgn = bgn - transfer_amount WHERE id = sender_id;

		UPDATE bank SET bgn = bgn + transfer_amount WHERE id = receiver_id;

		SELECT bgn FROM bank WHERE id = sender_id INTO temp_val;
		IF sender_amount - transfer_amount <> temp_val THEN
			status := 'Error when transfer from sender';
			ROLLBACK;
			RETURN;
		END IF;

		SELECT bgn FROM bank WHERE id = receiver_id INTO temp_val;
		IF receiver_amount + transfer_amount <> temp_val THEN
			status := 'Error when transfer to receiver';
			ROLLBACK;
			RETURN;
		END IF;
		status := 'Success';
		COMMIT;
	END;
$$

LANGUAGE plpgsql;



CALL sp_transfer_money(2, 1, 550, '')


SELECT * FROM bank;