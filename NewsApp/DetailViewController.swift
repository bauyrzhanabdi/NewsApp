import UIKit
import WebKit

final class DetailViewController: UIViewController {
    private var model: NewsModel?

    private lazy var descriptionLabel: UILabel = createLabel(text: "Description", fontSize: 12, fontWeight: 100)
    private lazy var publisherLabel: UILabel = createLabel(text: "Publisher", fontSize: 10, fontWeight: 100)
    private lazy var dateLabel: UILabel = createLabel(text: "Date", fontSize: 10, fontWeight: 100)
    private lazy var imageView: UIImageView = createImageView()
    private lazy var urlButton: UIButton = createButton()
    
    
    init(model: NewsModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = model?.title
        setup()
    }
    
    private func configure() {
        if let model = model {
            descriptionLabel.text = model.description
            publisherLabel.text = "Published by \(model.publisher)"
            dateLabel.text = model.date
            if let data = model.imageData {
                imageView.image = UIImage(data: data)
            }
        }
 
    }
    
    private func setup() {
        [descriptionLabel, publisherLabel, dateLabel, imageView, urlButton].forEach { subview in
            view.addSubview(subview)
        }
        configure()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 90),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            publisherLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            publisherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            dateLabel.leadingAnchor.constraint(equalTo: publisherLabel.trailingAnchor, constant: 100),
            
            urlButton.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 10),
            urlButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            urlButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    private func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createImageView() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .secondarySystemBackground
        return image
    }
    
    private func createButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Visit website", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(urlIsPressed), for: .touchUpInside)
        return button
    }
    
    private func createLabel(text : String, fontSize : CGFloat, fontWeight : CGFloat) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: fontWeight))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    @objc private func urlIsPressed(_ sender: UIButton) {
        guard let urlString = model?.websiteUrl else { return }
        let controller = WebViewController(url: urlString)
        navigationController?.pushViewController(controller, animated: true)
    }

    
    
    
}
