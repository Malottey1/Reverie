<?php
  $reference = $_GET['reference'];
  $url = "https://api.paystack.co/transaction/verify/" . $reference;

  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    "Authorization: Bearer sk_test_c276989ec344e7fa1eafa1bfcf19bbb4e4b7d459",
    "Cache-Control: no-cache",
  ));
  $response = curl_exec($ch);
  $err = curl_error($ch);

  curl_close($ch);
  
  if ($err) {
    echo "cURL Error #:" . $err;
  } else {
    echo $response;
  }
?>