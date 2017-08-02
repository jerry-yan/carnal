--Carnal Desire LV1
function c539193.initial_effect(c)
	c:SetSPSummonOnce(539193)
	c:EnableCounterPermit(0x660)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--counter for damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_DAMAGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c539193.addc)
    c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(539193,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c539193.spcost)
	e3:SetTarget(c539193.sptg)
	e3:SetOperation(c539193.spop)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(539193,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c539193.atkcond)
	e4:SetCost(c539193.atkcost)
	e4:SetTarget(c539193.atktg)
	e4:SetOperation(c539193.atkop)
	c:RegisterEffect(e4)
	--global check for summon limits
	if not c539193.global_check then
		c539193.global_check=true
		c539193[0]=false
		c539193[1]=false
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_SUMMON_SUCCESS)
		ge0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return eg:IsExists(function(c) return c:GetOriginalCode()==539193 end,1,nil)
		end)
		ge0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			c539193[ep]=true
		end)
		Duel.RegisterEffect(ge0,0)
		local ge1=ge0:Clone()
		ge1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge0:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			c539193[0]=false
			c539193[1]=false
		end)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD)
		ge4:SetCode(EFFECT_CANNOT_SUMMON)
		ge4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge4:SetTargetRange(1,1)
		ge4:SetValue(function(e,c,sump,sumtype,sumpos,targetp)
			return c:GetOriginalCode()==539193 and c539193[sump]
		end)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge4:Clone()
		ge5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge4:Clone()
		ge6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(ge6,0)
	end
end
c539193.lvupcount=1
c539193.lvup={90030966}
function c539193539193.addc(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		e:GetHandler():AddCounter(0x660,2)
	end
end
function c539193.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(e:GetHandler():GetCounter(0x660))
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c539193.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c539193.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c539193.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e:GetHandler():GetCounter(0x660),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c539193.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c539193.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c539193.atkcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c539193.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c539193.atkfilter(c)
	return c:IsFaceup() and c:IsCode(90030966)
end
function c539193.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c539193.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c539193.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c539193.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c539193.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end