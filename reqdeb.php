<?php
/**
 * This script sends n requests to a url and searches its response for phrases.
 * Author: Arne Gockeln <arne@gockeln.com>
 */ 
if($argc == 1){
	printf("Usage: %s [-nuos]\n\t[-n num] Send num requests\n\t[-u http...] The url to request\n\t[-o] Output response on hit\n\t[-s phrase1,phrase2,...] A comma seperated list of phrases\n", $argv[0]);
	exit();
}

$request_count = 10;
$request_host = 'https://qt.buzz09.de';
//$request_url = $request_host . '/wp-json/appbackend/v1/posts/0';
$request_url = $request_host . '/wp-json/appbackend/v1/config';
$search_phrases = ['Datenbankverbindung', 'Fehler'];

// ----------------------------------

function is_json($string){
	if(strlen($string) <= 0){
		return false;
	}

	return substr($string, 0, 1) == '{' && substr($string, -1) == '}';
}

$request_headers = [];
$request_headers[] = 'AppBackendToken: my_awesome_token';
$request_headers[] = 'Content-Type: application/json; charset=utf-8';
$request_headers[] = 'Language: de';

// -n 10 => send 10 requests
// -o => output response
// -u http... => the url to fetch
// -s search1,search2... => search these phrases
$options = getopt('n:ou:s:');
if(isset($options['n'])){
	if((int)$options['n'] > 0){
		$request_count = (int) $options['n'];
	}
}
$doOutput = false;
if(isset($options['o'])){
	$doOutput = true;
}
if(isset($options['u'])){
	if(strlen($options['u']) > 0 && stripos($options['u'], 'http') !== false){
		$request_url = $options['u'];
	}
}
if(isset($options['s']) && strlen($options['s']) > 0){
	$search_phrases = explode(',', $options['s']);
	if(!is_array($search_phrases)){
		$search_phrases = array($options['s']);
	}
}

$search_phrases_c = count($search_phrases);

$total_time = 0;
$total_hits = 0;
printf("Send %s requests to: %s\n", $request_count, $request_url);
printf("Search each response for: \n");
for($i = 0; $i < $search_phrases_c; $i++){
	printf("- %s\n", $search_phrases[$i]);
}
printf("--------------------------------------------\n");
for($i = 0; $i < $request_count; $i++){
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $request_url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_HTTPHEADER, $request_headers);

	$response = curl_exec($ch);
	$response_time = curl_getinfo($ch, CURLINFO_TOTAL_TIME);
	$total_time += $response_time;
	curl_close($ch);

	printf("=> Request: %s - %ss\n", $i + 1, number_format($response_time,2));
	
	if($doOutput){
		if( !is_json($response) ){
			printf("-- ERROR: No JSON! --\n");
		}
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
