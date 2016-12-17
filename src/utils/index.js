import { HttpClient } from 'aurelia-fetch-client';
import { tokenName, restUrl } from '../settings';
import CryptoJS from 'crypto-js';

const get_headers = () => {
  let headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*'
  }
  if (localStorage.getItem(tokenName)) {
    headers = Object.assign({}, ...headers, { 'Authorization': localStorage.getItem(tokenName) })
  }
  return headers;
}
const http = () => {
  return new HttpClient().configure(config => {
    config
      .withBaseUrl(restUrl)
      .withDefaults({
        mode: 'cors',
        headers: { ...get_headers() }
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
export function put(url, data) {
  const body = JSON.stringify(data);
  return http().fetch(url, { method: 'put', body: body })
    .then(checkStatus).then(parseJSON)
}
export function get(url) {
  return http().fetch(url, { method: 'get' })
    .then(checkStatus).then(parseJSON)
}
export function post(url, data) {
  const body = JSON.stringify(data);
  return http().fetch(url, { method: 'post', body: body })
    .then(checkStatus).then(parseJSON)
}
export function destroy(url) {
  return http().fetch(url, { method: 'delete' })
}
export const printArea = (id, title) => {  
  let links = `<link href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css' rel='stylesheet'/>;`
  let contents = document.getElementById(id).innerHTML;
  console.log(contents);
  let region = document.createElement('iframe');
  region.name = "region";
  region.style.position = "absolute";
  region.style.top = "-1000000px";
  document.body.appendChild(region);
  let frameDoc = region.contentWindow ? region.contentWindow : region.contentDocument.document ? region.contentDocument.document : region.contentDocument;
  frameDoc.document.open();
  frameDoc.document.write(`<html><head><title>${title}</title>${links}`);
  frameDoc.document.write('</head><body>');
  frameDoc.document.write(contents);
  frameDoc.document.write('</body></html>');
  frameDoc.document.close();
  setTimeout(()=>{
    window.frames["region"].focus();
    window.frames["region"].print();
    document.body.removeChild(region);
  }, 500);
  return false;
};

export const generateRandomNo = (min= 10, max = 10) => {  
  min = Math.ceil(1 + +"0".repeat(min));
  max = Math.floor(9 + +"9".repeat(max));  
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
export const doEncrypt = (str, key) => {
  return CryptoJS.AES.encrypt(str, key);
};
export const doDecrypt = (str, key) => {
  let decrypted = CryptoJS.AES.decrypt(str, key);
  return decrypted.toString(CryptoJS.enc.Utf8);
};
export const hashString = (str) => {
    var hash = CryptoJS.SHA512(str);
    var outString =  hash.toString(CryptoJS.enc.Hex);
    return outString.toUpperCase();
}
