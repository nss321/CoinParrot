//
//  CoinDetailViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/11/25.
//

import UIKit

import DGCharts
import Kingfisher
import RxSwift
import RxCocoa
import SnapKit
import Toast

final class CoinDetailViewController: BaseViewController {
    
    
    // MARK: NavigationBar
    private let customView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 24)
        return view
    }()
    
    private let symbol = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.kf.indicatorType = .activity
        view.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        return view
    }()
    
    private let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .coinParrotNavy
        return view
    }()
    
    
    // MARK: View
    private let container = UIView()
    
    private let scrollView = UIScrollView()
    
    private let currentPrice = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let changePercentageImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let changePercentageLabel = {
        let label = UILabel()
        label.font = .boldPrimary()
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let charts = {
        let chart = LineChartView()
        chart.noDataFont = .boldPrimary()
        chart.noDataTextColor = .coinParrotGray
        chart.noDataText = "차트 데이터를 불러올 수 없습니다."
        chart.backgroundColor = .clear
        chart.legend.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.drawLabelsEnabled = false
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.dragEnabled = false
        chart.highlightPerTapEnabled = false
        chart.setScaleEnabled(false)
        return chart
    }()
    
    private let timeStampLabel = {
        let label = UILabel()
        label.font = .regularSecondary()
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let marketInfoContainerLabel = {
        let label = UILabel()
        label.text = "종목정보"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let marketInfoMoreButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.configuration = .moreButtonStyle(title: "더보기")
        return button
    }()
    
    private let investContainerLabel = {
        let label = UILabel()
        label.text = "투자지표"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let investMoreButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        button.configuration = .moreButtonStyle(title: "더보기")
        return button
    }()
    
    
    // MARK: 종목정보 섹션
    private let marketInfoContainer = {
        let view = UIView()
        view.backgroundColor = .coinParrotLightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let highestPrice24hLabel = {
        let label = UILabel()
        label.text = "24시간 고가"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let highPrice24hContentLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let lowPrice24hLabel = {
        let label = UILabel()
        label.text = "24시간 저가"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let lowPrice24hContentLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let allTimeHighPriceLabel = {
        let label = UILabel()
        label.text = "역대 최고가"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let allTimeHighPriceContentLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let athTimeStampLabel = {
        let label = UILabel()
        label.font = .regularSecondary()
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let allTimeLowPriceLabel = {
        let label = UILabel()
        label.text = "역대 최저가"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let allTimeLowPriceContentLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let atlTimeStampLabel = {
        let label = UILabel()
        label.font = .regularSecondary()
        label.textColor = .coinParrotGray
        return label
    }()
    
    
    // MARK: 투자지표 섹션
    private let investContainer = {
        let view = UIView()
        view.backgroundColor = .coinParrotLightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let marketCapLabel = {
        let label = UILabel()
        label.text = "시가총액"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let marketCapContentLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let fullyDilutedValuationLabel = {
        let label = UILabel()
        label.text = "완전 희석 가치(FDV)"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let fullyDilutedValuationContentLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let totalVolumeLabel = {
        let label = UILabel()
        label.text = "총 거래량"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let totalVolumeContentLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let viewModel: CoinDetailViewModel
    
    init(viewModel: CoinDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func configLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(container)
        
        [
            currentPrice,
            changePercentageImageView,
            changePercentageLabel,
            charts,
            timeStampLabel,
            marketInfoContainerLabel,
            marketInfoMoreButton,
            marketInfoContainer,
            investContainerLabel,
            investMoreButton,
            investContainer
        ].forEach { container.addSubview($0) }
        
        [
            highestPrice24hLabel,
            highPrice24hContentLabel,
            lowPrice24hLabel,
            lowPrice24hContentLabel,
            allTimeHighPriceLabel,
            allTimeHighPriceContentLabel,
            athTimeStampLabel,
            allTimeLowPriceLabel,
            allTimeLowPriceContentLabel,
            atlTimeStampLabel
        ].forEach { marketInfoContainer.addSubview($0) }
        
        [
            marketCapLabel,
            marketCapContentLabel,
            fullyDilutedValuationLabel,
            fullyDilutedValuationContentLabel,
            totalVolumeLabel,
            totalVolumeContentLabel
        ].forEach { investContainer.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        currentPrice.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(largeMargin)
        }
        
        changePercentageImageView.snp.makeConstraints {
            $0.top.equalTo(currentPrice.snp.bottom)
            $0.leading.equalToSuperview().inset(largeMargin)
            $0.height.equalTo(14)
        }
        
        changePercentageLabel.snp.makeConstraints {
            $0.top.equalTo(currentPrice.snp.bottom)
            $0.leading.equalTo(changePercentageImageView.snp.trailing)
        }
        
        charts.snp.makeConstraints {
            $0.top.equalTo(changePercentageLabel.snp.bottom).offset(smallMargin)
            $0.horizontalEdges.equalToSuperview().inset(largeMargin)
            $0.height.equalTo(screenHeight/3)
        }
        
        timeStampLabel.snp.makeConstraints {
            $0.top.equalTo(charts.snp.bottom)
            $0.leading.equalToSuperview().inset(largeMargin)
        }
        
        marketInfoContainerLabel.snp.makeConstraints {
            $0.top.equalTo(timeStampLabel.snp.bottom).offset(largeMargin)
            $0.leading.equalToSuperview().inset(largeMargin)
        }
        
        marketInfoMoreButton.snp.makeConstraints {
            $0.centerY.equalTo(marketInfoContainerLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(largeMargin)
        }
        
        marketInfoContainer.snp.makeConstraints {
            $0.top.equalTo(marketInfoContainerLabel.snp.bottom).offset(largeMargin)
            $0.horizontalEdges.equalToSuperview().inset(largeMargin)
            $0.height.equalTo(140)
        }
        
        highestPrice24hLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(largeMargin)
        }
        
        highPrice24hContentLabel.snp.makeConstraints {
            $0.top.equalTo(highestPrice24hLabel.snp.bottom)
            $0.leading.equalTo(highestPrice24hLabel.snp.leading)
        }
        
        lowPrice24hLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(largeMargin)
            $0.leading.equalToSuperview().inset(screenWidth / 2 - CGFloat(smallMargin))
        }
        
        lowPrice24hContentLabel.snp.makeConstraints {
            $0.top.equalTo(lowPrice24hLabel.snp.bottom)
            $0.leading.equalTo(lowPrice24hLabel.snp.leading)
        }
        
        allTimeHighPriceLabel.snp.makeConstraints {
            $0.top.equalTo(highPrice24hContentLabel.snp.bottom).offset(smallMargin)
            $0.leading.equalTo(highestPrice24hLabel.snp.leading)
        }
        
        allTimeHighPriceContentLabel.snp.makeConstraints {
            $0.top.equalTo(allTimeHighPriceLabel.snp.bottom)
            $0.leading.equalTo(highestPrice24hLabel.snp.leading)
        }
        
        athTimeStampLabel.snp.makeConstraints {
            $0.top.equalTo(allTimeHighPriceContentLabel.snp.bottom)
            $0.leading.equalTo(highestPrice24hLabel.snp.leading)
        }
        
        allTimeLowPriceLabel.snp.makeConstraints {
            $0.top.equalTo(lowPrice24hContentLabel.snp.bottom).offset(smallMargin)
            $0.leading.equalTo(lowPrice24hLabel.snp.leading)
        }
        
        allTimeLowPriceContentLabel.snp.makeConstraints {
            $0.top.equalTo(allTimeLowPriceLabel.snp.bottom)
            $0.leading.equalTo(lowPrice24hLabel.snp.leading)
        }
        
        atlTimeStampLabel.snp.makeConstraints {
            $0.top.equalTo(allTimeLowPriceContentLabel.snp.bottom)
            $0.leading.equalTo(lowPrice24hLabel.snp.leading)
        }
        
        investContainerLabel.snp.makeConstraints {
            $0.top.equalTo(marketInfoContainer.snp.bottom).offset(largeMargin)
            $0.leading.equalToSuperview().inset(largeMargin)
        }
        
        investMoreButton.snp.makeConstraints {
            $0.centerY.equalTo(investContainerLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(largeMargin)
        }
        
        investContainer.snp.makeConstraints {
            $0.top.equalTo(investContainerLabel.snp.bottom).offset(largeMargin)
            $0.horizontalEdges.equalToSuperview().inset(largeMargin)
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview()
        }
        
        marketCapLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(largeMargin)
        }
        
        marketCapContentLabel.snp.makeConstraints {
            $0.top.equalTo(marketCapLabel.snp.bottom)
            $0.leading.equalTo(marketCapLabel.snp.leading)
        }
        
        fullyDilutedValuationLabel.snp.makeConstraints {
            $0.top.equalTo(marketCapContentLabel.snp.bottom).offset(mediumMargin)
            $0.leading.equalTo(marketCapLabel.snp.leading)
        }
        
        fullyDilutedValuationContentLabel.snp.makeConstraints {
            $0.top.equalTo(fullyDilutedValuationLabel.snp.bottom)

            $0.leading.equalTo(marketCapLabel.snp.leading)
        }
        
        totalVolumeLabel.snp.makeConstraints {
            $0.top.equalTo(fullyDilutedValuationContentLabel.snp.bottom).offset(mediumMargin)
            $0.leading.equalTo(marketCapLabel.snp.leading)
        }
        
        totalVolumeContentLabel.snp.makeConstraints {
            $0.top.equalTo(totalVolumeLabel.snp.bottom)
            $0.leading.equalTo(marketCapLabel.snp.leading)
        }
    
    }
    
    override func configView() {
        marketInfoMoreButton.addAction(UIAction(handler: { [weak self] _ in
            self?.view.makeToast("준비 중입니다.", duration: 1.5)
        }), for: .touchUpInside)
        investMoreButton.addAction(UIAction(handler: { [weak self] _ in
            self?.view.makeToast("준비 중입니다.", duration: 1.5)
        }), for: .touchUpInside)
        
        customView.addArrangedSubview(symbol)
        customView.addArrangedSubview(titleLabel)
        navigationItem.titleView = customView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "star")
        )
    }
    
    // MARK: DataBinding
    override func bind() {
        let input = CoinDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.coinDetailInformation
            .drive(with: self) { owner, response in
                if let item = response.first {
                    owner.updateNavigationBar(item: item)
                    owner.updateView(item: item)
                } else {
                    print("no response")
                }
            }
            .disposed(by: disposeBag)
    }
}

private extension CoinDetailViewController {
    func updateView(item: CoinDetail) {
        
        currentPrice.text = "₩" + checkNumber(number: item.currentPrice)
        
        if let changes = item.priceChangePercentage24h {
            
            if changes < 0 {
                changePercentageLabel.textColor = .coinParrotBlue
                changePercentageImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.coinParrotBlue, renderingMode: .alwaysOriginal)
                changePercentageLabel.text = checkNumber(number: -changes) + "%"
                
            } else if changes > 0 {
                changePercentageLabel.textColor = .coinParrotRed
                changePercentageImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(.coinParrotRed, renderingMode: .alwaysOriginal)
                changePercentageLabel.text = checkNumber(number: changes) + "%"
                
            } else {
                changePercentageLabel.textColor = .coinParrotNavy
                changePercentageLabel.text = checkNumber(number: changes) + "%"
                changePercentageLabel.snp.remakeConstraints {
                    $0.top.equalTo(currentPrice.snp.bottom)
                    $0.leading.equalToSuperview().inset(largeMargin)
                    
                }
                
            }
            
        }
        
        if let chartData = item.sparklineIn7d?.price {
            configChart(rawData: chartData)
        }
        
        
        timeStampLabel.text = item.lastUpdated
        
        highPrice24hContentLabel.text = "₩" + checkNumber(number: item.high24h ?? 0)
        
        lowPrice24hContentLabel.text = "₩" + checkNumber(number: item.low24h ?? 0)
        
        allTimeHighPriceContentLabel.text = "₩" + checkNumber(number: item.ath)
        
        athTimeStampLabel.text = item.athDate
        
        allTimeLowPriceContentLabel.text = "₩" + checkNumber(number: item.atl)
        
        atlTimeStampLabel.text = item.atlDate
        
        marketCapContentLabel.text = "₩" + checkNumber(number: item.marketCap)
        
        fullyDilutedValuationContentLabel.text = "₩" +  checkNumber(number: item.fullyDilutedValuation ?? 0)
        
        totalVolumeContentLabel.text = "₩" + checkNumber(number: item.totalVolume)
    }
    
    func configChart(rawData: [Double]) {
        
        var entries = [ChartDataEntry]()
        
        // dataset sampling
        rawData.enumerated().forEach {
            if $0 % 4 == 0 { entries.append(ChartDataEntry(x: Double($0), y: $1)) }
        }
        
        
        // config chart gradient
        let gradientColors = [
            ChartColorTemplates.colorFromString("#D9E1FC").cgColor,
            ChartColorTemplates.colorFromString("#4C80EE").cgColor
        ]
        
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        
        // config dataset
        let dataSet = LineChartDataSet(entries: entries)
        
        dataSet.mode = .cubicBezier
        
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = true
        
        dataSet.setColor(.coinParrotBlue)
        dataSet.lineWidth = 2
        
        dataSet.fillAlpha = 1
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        
        charts.data = LineChartData(dataSet: dataSet)
    }
    
    func updateNavigationBar(item: CoinDetail) {
        titleLabel.text = item.symbol.uppercased()
        
        if let url = URL(string: item.image) {
            symbol.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print("error occured", error)
                    self?.symbol.image = UIImage(systemName: "xmark")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
                }
            }
        } else {
            print("coin symbol image url is nil")
            symbol.image = UIImage(systemName: "xmark")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
        }
    }
    
    func checkNumber(number: Double) -> String {
        if hasDecimalPlaces(number: number) {
            return NumberFormatManager.shared.roundedNumeric(number: number)
        } else {
            return NumberFormatManager.shared.commaNumber(number: number)
        }
    }
    
    func hasDecimalPlaces(number: Double) -> Bool {
        let number = String(number)
        
        if let pointIndex = number.firstIndex(of: ".") {
            if number[pointIndex...] == ".0" {
                // 소수점 없는 숫자 -> comma
                return false
            } else {
                // 소수점 있는 숫자 -> round
                return true
            }
        } else {
            print("unexpected nil founded")
            print(number)
            return false
        }
    }
}
