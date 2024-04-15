import cv2
from grade import grade_paper
from flask import Flask, jsonify, request, jsonify, json
import os
import base64

# cv2.imshow("A", image)
# cv2.waitKey()

# tạo endpoint để chạy script
UPLOAD_FOLDER = "uploads"
ALLOWED_EXTENSIONS = {"png", "jpg", "jpeg"}
app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER


@app.route("/grade", methods=["POST"])
def grade_image():
    if request.method == "POST":
        if "file" not in request.files:
            return jsonify({"error": "No file part"})

        file = request.files["file"]
        id = request.form.get("session_id")

        if file.filename == "":
            return jsonify({"error": "No selected file"})

        if file:
            filename = file.filename
            if not os.path.exists(UPLOAD_FOLDER):
                os.makedirs(UPLOAD_FOLDER)
            current_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
            file.save(current_path)
            available_choices = int(request.form.get("available_choices", 5))

            right_answers = json.loads(
                request.form.get("right_answers", "{}")
            )  # convert json to dictionary
            right_answers = {int(key): value for key, value in right_answers.items()}
            print(right_answers)

            correct, graded_paper = grade_paper(
                current_path, available_choices, right_answers
            )

            # Remove the original image
            os.remove(current_path)

            # luu file anh chup
            if not os.path.exists(os.path.join(UPLOAD_FOLDER, id)):
                os.makedirs(os.path.join(UPLOAD_FOLDER, id))  # tao thu muc neu chua co

            folder_path = os.path.join(UPLOAD_FOLDER, id)
            file_count = len(os.listdir(folder_path))  # lay so file trong folder
            graded_paper_path = os.path.join(folder_path, str(file_count + 1) + ".png")
            cv2.imwrite(graded_paper_path, graded_paper)  # luu graded paper
            server_address = request.host_url  # lay dia chi server

            # json
            response_data = {
                "correct_answers": correct,
                "graded_paper_path": server_address + graded_paper_path,
            }

            return jsonify(response_data)
    return jsonify({"error": "Invalid request method"})


if __name__ == "__main__":
    app.run(port=8000)
