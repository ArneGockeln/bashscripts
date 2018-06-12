#!/usr/bin/php
<?php
/**
 * This script sends n requests to a url and searches its response for phrases.
 * Author: Arne Gockeln <arne@gockeln.com>
 */ 
if($argc == 1){
	$params = array(
		'[-n num]' => 'Send num requests, default is 5',
		'[-s phrase1,phrase2,...]' => 'A comma seperated list of phrases',
		'[-h header1,header2,...]' => 'A comma seperated list of headers',
		'[-o]' => 'Output every response instead on hit only',
		'[-j]' => 'Json response is expected'
	);
	printf("Usage: %s [-n:s:h:jo] http...\n", $argv[0]);
	foreach($params as $param => $param_desc){
		printf("\t%s %s\n", $param, $param_desc);
	}
	exit();
}

$request_count = 5;
$request_count_digits = 0;
$request_url = $argv[ $argc - 1 ];
$search_phrases = ['Datenbankverbindung', 'Fehler'];

// ----------------------------------
// default headers
$request_headers = [];
$request_headers[] = 'AppBackendToken: my_awesome_token';
$request_headers[] = 'Language: de';

// parse options
$options = getopt('n:ou:s:h:j');
// set request count, defaults to 10
if(isset($options['n'])){
	if((int)$options['n'] > 0){
		$request_count = (int) $options['n'];
		$request_count_digits = strlen((string) $request_count);
	}
}

// set output option, defaults to false
$doOutput = false;
if(isset($options['o'])){
	$doOutput = true;
}

// sets url
if(isset($options['u'])){
	if(strlen($options['u']) > 0 && stripos($options['u'], 'http') !== false){
		$request_url = $options['u'];
	}
}
if( empty($request_url) ){
	printf("Error: no url found.\n");
	exit();
}

// set search phrases
if(isset($options['s']) && strlen($options['s']) > 0){
	$search_phrases = explode(',', $options['s']);
	if(!is_array($search_phrases)){
		$search_phrases = array($options['s']);
	}
}

// set headers
if(isset($options['h']) && strlen($options['h']) > 0){
	$headers = explode(',', $options['h']);
	if(!is_array($headers)){
		$headers = array($options['h']);
	}

	foreach($headers as $plus_header){
		$request_headers[] = $plus_header;
	}
}

// set json request header
if(isset($options['j'])){
	$request_headers[] = 'Content-Type: application/json; charset=utf-8';
} else {
	$request_headers[] = 'Content-Type: text/html; charset=utf-8';
}

$search_phrases_c = count($search_phrases);
$request_headers_c = count($request_headers);

$total_time = 0;
$total_hits = 0;
printf("[Config]\n- %s Requests\n- Url: %s\n", $request_count, $request_url);
printf("[Headers]\n");
for($i0 = 0; $i0 < $request_headers_c; $i0++){
	printf("- %s\n", $request_headers[$i0]);
}
printf("[Search each response] \n");
for($i1 = 0; $i1 < $search_phrases_c; $i1++){
	printf("- %s\n", $search_phrases[$i1]);
}
$terminal_width = (int)exec('tput cols') - 2;
$dashes = '';
for($i = 0; $i < $terminal_width; $i++){
	$dashes .= '-';
}
printf("[%s]\n", $dashes);
for($i = 0; $i < $request_count; $i++){
	$ch = curl_init();
	// set url for request
	curl_setopt($ch, CURLOPT_URL, $request_url);
	// return response as string
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	// set http headers
	curl_setopt($ch, CURLOPT_HTTPHEADER, $request_headers);
	// force new cookie session
	curl_setopt($ch, CURLOPT_COOKIESESSION, 1);
	// close connection explicitly
	curl_setopt($ch, CURLOPT_FORBID_REUSE, 1);
	// force new connect
	curl_setopt($ch, CURLOPT_FRESH_CONNECT, 1);

	$response = curl_exec($ch);
	$response_time = curl_getinfo($ch, CURLINFO_TOTAL_TIME);
	$response_size = curl_getinfo($ch, CURLINFO_SIZE_DOWNLOAD);
	$response_size = $response_size * 0.001;
	$total_time += $response_time;
	curl_close($ch);

	printf("> Request: % ".$request_count_digits."d - %ss - %s KB\n", $i + 1, number_format($response_time,2), number_format($response_size, 2));
	
	if($doOutput){
		printf("%s\n", $response);
	}

	for($s = 0; $s < $search_phrases_c; $s++){
		if( stripos($response, $search_phrases[ $s ]) !== false ){
			$total_hits++;
			printf("-- Found >%s< in:\n%s\n", $search_phrases[$s], ($doOutput ? 'response' : $response));
		}
	}
}
printf("Total %s requests in %ss with %s search hits.\n", $request_count, number_format($total_time,2), $total_hits);
