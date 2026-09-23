from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def calculate():
    result = None
    error = None

    if request.method == 'POST':
        try:
            num1 = float(request.form.get('num1'))
            num2 = float(request.form.get('num2'))
            operation = request.form.get('operation')
        except (TypeError, ValueError):
            error = 'Please enter valid numbers.'
        else:
            if operation == 'add':
                result = num1 + num2
            elif operation == 'subtract':
                result = num1 - num2
            elif operation == 'multiply':
                result = num1 * num2
            elif operation == 'divide':
                if num2 == 0:
                    error = 'Division by zero is not allowed.'
                else:
                    result = num1 / num2
            else:
                error = 'Invalid operation.'

    return render_template('index.html', result=result, error=error)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')