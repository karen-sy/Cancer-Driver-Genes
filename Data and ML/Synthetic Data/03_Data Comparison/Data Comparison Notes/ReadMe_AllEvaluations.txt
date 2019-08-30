Data comparison notes
indices of tested features...
    #1: [3 3 9 6 7 1 3 2]; --> tested (3 vs 1), (3 vs 2), (9 vs 5)...
    #2: [1 2 5 6 7 10 11 12];
r = linear correlation coefficient
*for all features: LEFT = Synthetic, RIGHT = Consensus
 
(1) MisFrac to SilFrac (31.png, 31_2.png) --> NAMES ARE MESSED UP IMAGES; follow this text
    r_syn = -0.8951
    r_con = -0.6664
    -both moderately strong correlation
    -both for OG and TSG, synthetic data is more concentrated on the peak
    (see density values, esp. for TSG)
    -TSG values are more focused (near peak) in range, OG is closer to consensus
    -but synthetic and consensus data (og, tsg, overall ) have similar peak values
    -can say synthetic brings out the existing pattern in consensus

(2) MisFrac to NonFrac (32.png) --> NAMES ARE MESSED UP IN IMAGES; follow this text
    r_syn = -0.3166
    r_con = -0.2195
    -both weak linear correlation --> what other 'pattern', replicated correctly?
    -since misfrac,silfrac explored in (1), focus on nonfrac: (32_2.png shows nonfrac ('y') vs density ('z'))
    -again, similar peaks for og and tsg (0.03...),     
    -TSG values are more focused (near peak) in range, OG is closer to consensus

(3) MissenseEntropy to MisToSil (95.png)
    r_syn = -0.0839
    r_con = 0.2038
    -i mean, the two do not have much of a relationship; rather observe the entropy distribution in 95.png
    -synthetic: og, tsg have lower entropy (--> makes sense; more clustering) than entire distribution including passengers
    -consensus: above pattern doesn't exactly match; both og and tsg peak at ~1, 
                but og and tsgs have small peaks at <1, indicating that some og's and tsg's have distinguishably low entropy
    -again we have 'brought out' important traits

(4) NonSiltoSil to itself (66.png)
    -checking if its distribution is "too far off"
    -passenger distribution is quite far off in terms of where it peaks
        (Synthetic: Nonsil = usually 2.5~2.7 times Sil) (Consensus: Nonsil = usually 4.6~6.4 times Sil)
    -oncogene distribution is more similar in peak location but much denser at peak for synthetic
    -tsg is again much more dense at peak, much less variance (range is different)
    -perhaps the justification for silent, nonsilent, and missense already imply that nonsilToSil is okay

(5) GeneCount to itself (77.png) *reminder: geneCount = how many patients gene shows up in (a bit of misnomer)
    -synthetic: og and especially tsg shows up in more samples than the average gene
    -consensus: this is not true (og and tsg on average does not show up more often),
    -but it is reasonable to postulate that the more often a gene appears in cancerous cells, it is not incidental but a driver

(6) SilFrac to MutationEntropy (110.png --> shows mutation entropy)
    -r_syn = 0.0045
    -r_con = 0.0364
    -og pattern similar for two datasets (concentrated at slightly lower entropy, smaller hills)
    -synthetic tsg has much much lower peak; this is a little hard to justify (unless mutentropy turns out to be significant feature)
        possible idea: perhaps the tsg's that the synthetic data 'sampled' happen to ovverrepresent the small hills of the consensus

(7) MisFrac to MisPval(311.png ; the synthetic og has higher peak at 1, notice overlapping peak there)
    -r values don't matter since bimodal
    -(the graphs are continuous but aren't 100% accurate, extrapolated)
    -similar trends for two data sets: majority of og's and tsg's have lower pval
    -very low pvals are very (see density) overrepresented in synthetic dataset, underrepresentation of middle and top pvals
    -in synthetic, low misPval (=it's rare for that gene to be missense mutated) maybe a good indicator of tsg, like in consensus (diff is more pronounced in tsg than og there too)
    -may not help as much for og's because it has bimodal distribution like the overall

(8) NonFrac to NonPval (212.png; just nonPval plane)
    -similar distribution for passenger, og, tsg
    -for both: pronounced left peak for og and peak of tsg is distinguishable from overall dist.

(9) SilPval to SilPval (1313.png)
    -(spoiler: not important feature from previous models)
    -synthetic is too bimodal in overall distribution, tsg distribution doesn't match consensus, oncogene's left epak too high
    -seems to accentuate los pvals across og and tsg; not entirely sure if 'useful' or even 'accurate' because many passengers have high pvals too

(10) GeneLength to GeneLength (88.png)
    -for both datasets the og and tsg distributions are very close with overall distributions
    -so does not provide much information

(11) R_MisFrac to R_MisFrac (44.png)
    -Distribution of all are different across datasets; will not be used since missenseEntropy achieves same purpose



==> omit R_MisFrac, GeneLength, optionally SilentPval

