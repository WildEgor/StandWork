from random import randint
from opcua import ua, Server
import datetime
import time
import requests
from requests.exceptions import HTTPError
import json

camUrl = 'http://192.168.99.8/CmdChannel?gRES'

ThingSpeakAPIKeyRead = '60P2Y5Y59K8HEN7X'
ThingSpeakAPIKeyWrite = 'R2ZF7TFQ8BHM7BYH'
ThingSpeakBaseUrlRead = 'https://api.thingspeak.com/channels/1153290/feeds.json?'
ThingSpeakBaseUrlWrite = 'https://api.thingspeak.com/update?'
channelNum = '1'
urlForRead = ThingSpeakBaseUrlRead + "api_key=" + ThingSpeakAPIKeyRead + "&results=" + channelNum
urlForWrite = ThingSpeakBaseUrlWrite + 'api_key=' + ThingSpeakAPIKeyWrite

openWeatherAPI = 'eb6132ec7333f86c5e9bed005c6ac9fc'
openWeatherCity = 'Almaty'
openWeatherUrl = 'https://api.openweathermap.org/data/2.5/weather?q=' + openWeatherCity + '&appid=' + openWeatherAPI + '&units=metric'

OPCserver = Server()
OPCurl = 'opc.tcp://127.0.0.1:4840/FreeOPCServer'
OPCname = 'FreeOPCUA'

OPCserver.set_endpoint(OPCurl)
addSpace = OPCserver.register_namespace(OPCname)
node = OPCserver.get_objects_node()

ParamList = node.add_object(addSpace, 'Parameters')
Temp = ParamList.add_variable(addSpace, 'Temperature', 0)
Press = ParamList.add_variable(addSpace, 'Pressure', 0)
Time = ParamList.add_variable(addSpace, 'Time', 0)
ThingSpeakData = ParamList.add_variable(addSpace, 'ThingSpeak', 0)
OpenWeatherData = ParamList.add_variable(addSpace, 'AlmatyTemperature', 0)
CameraScore = ParamList.add_variable(addSpace, 'CameraScore', 0)
CameraPixels = ParamList.add_variable(addSpace, 'CameraPixels', 0)

Temp.set_writable()
Press.set_writable()
Time.set_writable()
ThingSpeakData.set_writable()
OpenWeatherData.set_writable()
CameraScore.set_writable()
CameraPixels.set_writable()

OPCserver.start()
print('Server start'.format(OPCurl))


def postHTTP(url, postData = {'field1': '0'}, timeOut = 0.5):
    try:
        responseHTTP = requests.post(url, data=postData, timeout=timeOut)
        responseHTTP.raise_for_status()
    except HTTPError as http_err:
        #print(f'HTTP error occurred: {http_err}')
        return 401
    except Exception as err:
        #print(f'Other error occurred: {err}')
        return 404
    else:
        #print('POST Success!')
        return 200


def getHTTP(url, timeOut):
    try:
        responseHTTP = requests.get(url, timeout=timeOut)
        # jsonResponse = responseHTTP.json()
        #print(responseHTTP.content)
        #print(responseHTTP.status_code)
        #print(responseHTTP.headers)
        #print(responseHTTP.json)
        jsonResponse = responseHTTP.content
    except HTTPError as http_err:
        print(f'HTTP error occurred: {http_err}')
        return 401
    except Exception as err:
        print(f'Other error occurred: {err}')
        return 404
    else:
        #print('GET Success!')
        return jsonResponse

if __name__ == "__main__":
    try:
        field1 = 0
        AlmatyTemp = 0
        field1Old = 0
        AlmatyTempOld = 0
        while True:
            start_time_loop = time.time()

            # # Запись
            # print('POST ThingSpeak: Try...')
            # myData = {'field1': randint(999, 9999)}
            # response = postHTTP(urlForWrite, myData, 0.5)
            #
            # if response == 404 or response == 401:
            #     print('POST ThingSpeak: Error :(')
            # else:
            #     print('POST ThingSpeak: Done!')
            #
            # print('Try ThingSpeak GET...')
            # JsonResponse = getHTTP(urlForRead, 3)
            # if JsonResponse == 401 or JsonResponse == 404:
            #     print('GET Error')
            #     field1 = field1Old
            # else:
            #     print('Success GET!')
            #     feeds = JsonResponse['feeds']
            #     field1 = feeds[0]['field1']
            #     field1Old = field1
            #
            # print('GET OpenWeather: Try...')
            # print(openWeatherUrl)
            # OpenWeatherJson = getHTTP(openWeatherUrl, 3)
            # if OpenWeatherJson == 401 or OpenWeatherJson == 404:
            #     print('GET OpenWeather: Error :(')
            #     AlmatyTemp = AlmatyTempOld
            # else:
            #     print('GET OpenWeather: Done!')
            #     # print(OpenWeatherJson)
            #     main = OpenWeatherJson['main']
            #     AlmatyTemp = main['temp']
            #     AlmatyTempOld = AlmatyTemp

            print('GET Cam: Try...')
            print(camUrl)
            CamJson = getHTTP(camUrl, 1)
            if CamJson == 401 or CamJson == 404:
                print('GET Cam: Error :(')
            else:
                print('GET Cam: Done!')
                #print(CamJson)
                CamTemp = CamJson.decode("utf-8")
                CamJsonParse = CamTemp.replace('rgRES 0 ', '')
                CamJsonDone = json.loads(CamJsonParse)
                ObjLoc = CamJsonDone['MESSAGE']['OBJECT_LOC']
                PixelCount = CamJsonDone['MESSAGE']['Pixel_counter_1']
                CamScore = ObjLoc['SCORE']
                CamPixel = PixelCount['PIXELS']

            # # Время цикла
            # overAllTime = time.time() - start_time_loop
            # print('HTTP time: {}'.format(overAllTime))
            #
            # if overAllTime > 2:
            #     print('Time', start_time_loop)
            #     pass
            # else:
            #     timeout = abs(2 - (time.time() - start_time_loop))
            #     time.sleep(timeout)
            #     print('Work in process...'+ str(round(timeout)) + ' s')
            time.sleep(1)
            Temperature = randint(10, 50)
            Pressure = randint(200, 999)
            Timer = datetime.datetime.now()

            Temp.set_value(Temperature)
            Press.set_value(Pressure)
            Time.set_value(Timer)
            ThingSpeakData.set_value(field1)
            OpenWeatherData.set_value(AlmatyTemp)
            CameraScore.set_value(CamScore)
            CameraPixels.set_value(CamPixel)
            print(CamScore)
            print(CamPixel)
    finally:
        OPCserver.stop()
