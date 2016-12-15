import { HttpClient } from 'aurelia-fetch-client';
import {tokenName, restUrl} from '../settings';

const get_headers = () => {
  let headers = {
   'Accept': 'application/json',
   'Content-Type': 'application/json',
   'Access-Control-Allow-Origin':'*'
 }
 if(localStorage.getItem(tokenName)){
   headers = Object.assign({}, ...headers, {'Authorization': localStorage.getItem(tokenName)})
 }
 return headers;
}
const http = () => {
  return new HttpClient().configure(config => {
    config
    .withBaseUrl(restUrl)
    .withDefaults({
        mode: 'cors',
        headers: {...get_headers()}
      })
  });
}

function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  } else {
    var error = new Error(response.statusText);
    error.response = response;
    throw error;
  }
}

function parseJSON(response) {
  return response.json();
}
export function put(url, data){
  const body = JSON.stringify(data);
  return http().fetch(url, { method: 'put', body: body })
  .then(checkStatus).then(parseJSON)
}
export function get(url){
  return http().fetch(url, { method: 'get' })
  .then(checkStatus).then(parseJSON)
}
export function post(url, data){
  const body = JSON.stringify(data);
  return http().fetch(url, { method: 'post', body: body })
  .then(checkStatus).then(parseJSON)
}
export function destroy(url){
  return http().fetch(url, { method: 'delete' })
}
