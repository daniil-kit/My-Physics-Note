{
    TH1F *h1 = new TH1F("h1", "Random gauss;X;Entries", 100, -2, 2);
    h1->FillRandom("gaus", 100);
    h1-> GetXaxis() -> SetTitleOffset(1.3);
    h1-> GetYaxis() -> SetTitleOffset(1.1);
    h1->Integral();
    h1->Draw("X+Y+ E X0");
}