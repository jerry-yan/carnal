--Carnal Desire LV7
function c47880400.initial_effect(c)
	c:SetSPSummonOnce(47880400)
	c:EnableCounterPermit(0x660)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--skip mp1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47880400,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c47880400.skipcond)
	e2:SetTarget(c47880400.skiptg)
	e2:SetOperation(c47880400.skipop)
	c:RegisterEffect(e2)
	--counter for damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c47880400.addc)
    c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47880400,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c47880400.spcost)
	e4:SetTarget(c47880400.sptg)
	e4:SetOperation(c47880400.spop)
	c:RegisterEffect(e4)
	--protection
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47880400,2))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c47880400.effcost)
	e5:SetTarget(c47880400.efftg)
	e5:SetOperation(c47880400.effop)
	c:RegisterEffect(e5)
	--global check for summon limits
	if not c47880400.global_check then
		c47880400.global_check=true
		c47880400[0]=false
		c47880400[1]=false
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_SUMMON_SUCCESS)
		ge0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return eg:IsExists(function(c) return c:GetOriginalCode()==47880400 end,1,nil)
		end)
		ge0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			c47880400[ep]=true
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
			c47880400[0]=false
			c47880400[1]=false
		end)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD)
		ge4:SetCode(EFFECT_CANNOT_SUMMON)
		ge4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge4:SetTargetRange(1,1)
		ge4:SetValue(function(e,c,sump,sumtype,sumpos,targetp)
			return c:GetOriginalCode()==47880400 and c47880400[sump]
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
c47880400.lvupcount=1
c47880400.lvup={12827544}
c47880400.lvdncount=2
c47880400.lvdn={539193,90030966}
function c47880400.skipcond(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c47880400.retfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeck()
end
function c47880400.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c47880400.retfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c47880400.retfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c47880400.skipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)	
	end
end
function c47880400.addc(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		e:GetHandler():AddCounter(0x660,2)
	end
end
function c47880400.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(e:GetHandler():GetCounter(0x660))
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c47880400.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv+6) and c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c47880400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c47880400.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e:GetHandler():GetCounter(0x660),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c47880400.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47880400.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c47880400.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c47880400.efffilter(c)
	return c:IsFaceup() and c:IsCode(12827544)
end
function c47880400.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c47880400.efffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47880400.efffilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c47880400.efffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47880400.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
	end
end