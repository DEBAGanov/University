import cv2

capture = cv2.VideoCapture(0)
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
face_eye = cv2.CascadeClassifier('haarcascade_eye.xml')
# face_cascade = cv2.CascadeClassifier('haarcascade_smile.xml')
while True:
    ret, img = capture.read()

    faces = face_cascade.detectMultiScale(img, scaleFactor=2, minNeighbors=3, minSize=(20, 20))
    eyes = face_eye.detectMultiScale(img, scaleFactor=2, minNeighbors=3, minSize=(10, 10))

    for(x, y, w, h) in faces:
        cv2.rectangle(img, (x, y), (x+w, y+h), (0, 255, 0), 2)
        for (ex, ey, ew, eh) in eyes:
            cv2.rectangle(img, (ex, ey), (ex + ew, ey + eh), (0, 255, 0), 2)
    cv2.imshow("From Camera", img)
    k = cv2.waitKey(30) & 0xFF
    if k == 27:
     break

capture.release()
cv2.destroyAllWindows()

