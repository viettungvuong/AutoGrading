import cv2
import numpy as np
from scan import scan
import imutils
from imutils import contours
import argparse


def grade_paper(imagepath, available_choices=5, answers={0: 1, 1: 1, 2: 0, 3: 3, 4: 4}):
    image = cv2.imread(imagepath)
    scanned = scan(image)  # scan hinh

    # lam hinh trang hon
    image_float = scanned.astype(np.float32) / 255.0
    factor = 1.5
    whiter_image_float = image_float * factor
    whiter_image_float = np.clip(whiter_image_float, 0.0, 1.0)
    scanned = (whiter_image_float * 255).astype(np.uint8)

    cv2.imshow("Scanned", scanned)
    cv2.waitKey(0)

    # chia phan trang va den tren anh
    gray = cv2.cvtColor(scanned, cv2.COLOR_BGR2GRAY)
    thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU)[1]
    cv2.imshow("Thresh", thresh)
    cv2.waitKey(0)

    # tim contour trong hinh da binary thanh den trang
    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)
    scanned_cnts = scanned.copy()
    cv2.drawContours(scanned_cnts, cnts, -1, (0, 255, 0), 2)
    cv2.imshow("Scanned with Contours", scanned_cnts)
    cv2.waitKey(0)
    questionCnts = []
    for c in cnts:
        (_, _, w, h) = cv2.boundingRect(c)
        aspect_ratio = w / float(h)
        circle_threshold = 0.85
        # dieu kien de mot contour la cau hoi => phai ktra tron
        if (
            w >= 30
            and h >= 30
            and circle_threshold <= aspect_ratio <= 1 / circle_threshold
        ):
            questionCnts.append(c)
    scanned_questcnts = scanned.copy()
    cv2.drawContours(scanned_questcnts, questionCnts, -1, (0, 255, 0), 2)
    cv2.imshow("Scanned with Question Contours", scanned_questcnts)
    cv2.waitKey(0)

    scanned_each_quest = scanned.copy()
    # sort cac contour theo thu tu tu tren xuong duoi
    questionCnts = contours.sort_contours(questionCnts, method="top-to-bottom")[0]
    correct = 0
    for q, i in enumerate(np.arange(0, len(questionCnts), available_choices)):
        cnts = contours.sort_contours(questionCnts[i : i + available_choices])[
            0
        ]  # cac contour cua hang hien tai
        cv2.drawContours(scanned_each_quest, cnts, -1, (0, 255, 0), 2)
        cv2.imshow("Scanned with Each Question Contours", scanned_each_quest)
        cv2.waitKey(0)
        bubbled = None

        for j, c in enumerate(cnts):
            mask = np.zeros(thresh.shape, dtype="uint8")
            cv2.drawContours(mask, [c], -1, 255, -1)
            # chuyen qua den trang de de nhan dien cau nao da khoanh va cau nao chua
            mask = cv2.bitwise_and(thresh, thresh, mask=mask)
            # cv2.imshow("Mask question", mask)
            # cv2.waitKey(0)
            total = cv2.countNonZero(mask)  # % phan khong trang (phan to den)
            # dap an khoanh la dap an co phan mau den nhieu hon
            if bubbled is None or total > bubbled[0]:
                bubbled = (total, j)

        k = answers[q]
        if k == bubbled[1]:
            color = (0, 255, 0)  # mau xanh
            correct += 1
        else:
            color = (0, 0, 255)  # mau do
        cv2.drawContours(scanned, [cnts[k]], -1, color, 3)
    cv2.imshow("Result", scanned)
    cv2.waitKey(0)
    return (correct, scanned)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Select image.")
    parser.add_argument("image_path", type=str, help="Path to the input image.")
    args = parser.parse_args()

    image_path = args.image_path
    result_image = grade_paper(image_path)
