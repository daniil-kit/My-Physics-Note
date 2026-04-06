{
    TFile *file = new TFile("scrip2.root");
    TH1F *h1 = (TH1F*)file->Get("h");
    h1 -> Draw();
}