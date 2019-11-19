import cv2

def dispWebcam(url):
    cap = cv2.VideoCapture(url)
    
    while True:
        ret, frame = cap.read()
        cv2.imshow('webcam', frame)

        #if cv2.waitKey(1) == 27: # press ESC to exit
        if cv2.waitKey(1) & 0xFF == ord('q'): # press q to exit
            exit(0)

