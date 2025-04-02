import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelUI()
        
        let buttonTitle = ["7", "8", "9", "+", "4", "5", "6", "-", "1", "2", "3", "*", "AC", "0", "=", "/"]
        let button = buttonTitle.map { ButtonUI(title: $0) }
        
        let orangeButton = [3, 7, 11, 12, 14, 15] // "+", "-", "=", "AC", "=", "/"
        for index in orangeButton {
            button[index].backgroundColor = .orange
        }
        
        let stackView1 = makeHorizontalStackView([button[0],button[1],button[2],button[3]])
        stackView1.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        let stackView2 = makeHorizontalStackView([button[4],button[5],button[6],button[7]])
        
        let stackView3 = makeHorizontalStackView([button[8],button[9],button[10],button[11]])
        
        let stackView4 = makeHorizontalStackView([button[12],button[13],button[14],button[15]])
        
        let stackview = makeverticalStackview([stackView1,stackView2,stackView3,stackView4])
        view.addSubview(stackview)
        stackview.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(60)
            $0.width.equalTo(350)
            $0.centerX.equalToSuperview()
        }
    }
        
    
    // 라벨 속성
    func LabelUI() {
        view.backgroundColor = .black // 백그라운드 색
        label.text = "0" // 텍스트 60 고정
        label.textColor = .white // 텍스트 색
        label.textAlignment = .right // 텍스트 오른쪽 정렬
        label.font = UIFont.systemFont(ofSize: 60) // Font = 시스템 볼드체, 사이즈 60
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30) // leading, trailing = superView로 부터 30 떨어지게 세팅
            $0.top.equalToSuperview().inset(200) // top = superView로 부터 200 떨어지게 세팅
            $0.height.equalTo(100) // height = 100
        }
        
    }
    // 버튼 속성
    func ButtonUI(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30) // 버튼에서는 titleLabel?.font를 사용해서 폰트변경 가느
        button.layer.cornerRadius = 40 // layer.cornerRadius = 40
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    
    }
    
    // 가로 스택뷰 속성
    func makeHorizontalStackView(_ views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal // axis = .horizontal
        stackView.backgroundColor = .black // backgroundColor = .black
        stackView.spacing = 10 // spacing = 10
        stackView.distribution = .fillEqually // distribution = .fillEqually
        
        return stackView
    }

    // 세로 스택뷰 속성 설정은 세로 스택뷰와 동일하게
    func makeverticalStackview(_ view: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: view)
        stackView.axis = .vertical
        stackView.backgroundColor = .black
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        return stackView
    }
        /// 수식 문자열을 넣으면 계산해주는 메서드.
        ///
        /// 예를 들어 expression 에 "1+2+3" 이 들어오면 6 을 리턴한다.
        /// 잘못된 형식의 수식을 넣으면 앱이 크래시 난다. ex) "1+2++"
        func calculate(expression: String) -> Int? {
            let expression = NSExpression(format: expression)
            if let result = expression.expressionValue(with: nil, context: nil) as? Int {
                return result
            } else {
                return nil
            }
        }
        
    
    
    // 액션함수
    @objc func buttonTapped(_ sender: UIButton) {
        let title = sender.currentTitle ?? ""
        // "AC" 버튼이 눌리면 0으로 초기화
        if title == "AC" {
            label.text = "0"
            // "=" 버튼이 눌리면 연산을 함
        } else if title == "=" {
            let result = calculate(expression: label.text ?? "" )
            label.text = "\(result ?? 0)"
        }
        // 연산자가 연속으로 두번 쓰이는 것을 방지
        else if ["+", "-", "*", "/"].contains(title) {
            if let lastChar = label.text?.last, ["+", "-", "*", "/"].contains(String(lastChar)) {
                label.text?.removeLast()
            }
            label.text?.append(title)
            // 처음에 0이면 버튼의 타이틀로 바뀜
        } else {
            if label.text == "0" {
                label.text = title
                // 그렇지 않으면 계속해서 버튼의 타이틀이 라벨이 쌓임
            } else {
                label.text?.append(title)
            }
        }
    }
    
  
}



