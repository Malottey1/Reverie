<?php
  $url = "https://api.paystack.co/transaction/initialize";
  $fields = [
    'email' => $_POST['email'],
    'amount' => $_POST['amount'],
  ];
  $fields_string = http_build_query($fields);

  $ch = curl_init();
  curl_setopt($ch,CURLOPT_URL, $url);
  curl_setopt($ch,CURLOPT_POST, true);
  curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
  curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    "Authorization: Bearer sk_test_c276989ec344e7fa1eafa1bfcf19bbb4e4b7d459",
    "Cache-Control: no-cache",
  ));
  curl_setopt($ch,CURLOPT_RETURNTRANSFER, true); 
  $result = curl_exec($ch);
  echo $result;
?>