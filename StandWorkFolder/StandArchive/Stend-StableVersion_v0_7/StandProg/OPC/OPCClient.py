from opcua import ua, Client
import time

if __name__ == "__main__":
    url = 'opc.tcp://127.0.0.1:4840/FreeOPCServer'

    client = Client(url)

    client.connect()
    print('Client Connect')

    while True:
        Temp = client.get_node('ns = 2; i = 2')
        Temperature = Temp.get_value()
        print(Temperature)

        Press = client.get_node('ns = 2; i = 3')
        Pressure = Press.get_value()
        print(Pressure)

        Time = client.get_node('ns = 2; i = 4')
        CurTime = Time.get_value()
        print(CurTime)
        time.sleep(1)

        JsonResponse = client.get_node('ns = 2; i = 5')
        JsonValue = JsonResponse.get_value()
        print(JsonValue)
        time.sleep(1)