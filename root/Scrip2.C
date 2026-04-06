{
    TH2F *h = new TH2F("h", "Histo ", 1000, 0, 10, 1000, -100, 100);
    TFile *f = new TFile("scrip2.root", "RECREATE");
    TRandom3 *r = new TRandom3();
    Double_t x,y,z;
    for(Int_t i =0; i < 10000; i++){
        x = r->Uniform(0,10);
        z = r->Gaus(0,1);
        y = x*z;
        h -> Fill(x,y);
    }
    TProfile *prof = new TProfile("prof", " ",1000, 0, 10);
    prof = h -> ProfileX();
    h -> Draw("COLZ");
    prof -> SetLineColor(kBlue);
    prof -> SetLineWidth(4);
    prof -> Draw("SAME");
    h -> Write();
    prof -> Write();
    f->Close();
}