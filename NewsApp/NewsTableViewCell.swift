import UIKit

final class NewsModel {
    let title: String
    let publisher: String
    let description: String
    let websiteUrl: String
    let date: String
    let imageUrl: URL?
    var imageData: Data? = nil
    
    init(title: String, publisher: String, description: String, websiteUrl: String, date: String, imageUrl: URL?) {
        self.title = title
        self.publisher = publisher
        self.description = description
        self.websiteUrl = websiteUrl
        self.date = date
        self.imageUrl = imageUrl
    }
}

final class NewsTableViewCell: UITableViewCell {
    public lazy var view: UIView = createView()
    private lazy var title: UILabel = createLabel(text: "Title", fontSize: 12, fontWeight: 200)
    private lazy var image: UIImageView = createImageView()
    public lazy var count: UILabel = createLabel(text: "View count: 0", fontSize: 10, fontWeight: 20)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        count.text = nil
        image.image = nil
    }
    
    func configure(with model: NewsModel) {
        title.text = model.title
        setImage(model: model, data: model.imageData, url: model.imageUrl)
    }
    
    private func setImage(model: NewsModel, data: Data?, url: URL?) {
        if let data = data {
            image.image = UIImage(data: data)
        } else if let url = url {
            loadImage(model: model, url: url)
        }
    }
    
    private func loadImage(model: NewsModel, url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            model.imageData = data
            DispatchQueue.main.async {
                self?.image.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    private func setup() {
        contentView.addSubview(view)
        
        [title, image, count].forEach { subview in
            view.addSubview(subview)
        }

        view.layer.cornerRadius = 16
        view.clipsToBounds = true

        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),

            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            count.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            count.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 1)
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
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.backgroundColor = .secondarySystemBackground
        return image
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
}


